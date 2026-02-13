class Customer::WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = ENV['STRIPE_WEBHOOK_SECRET'] || Rails.application.credentials.dig(:stripe, :endpoint_secret)
    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
    rescue JSON::ParserError => e
      p e
      status 400
      return
    rescue Stripe::SignatureVerificationError => e
      p e
      status 400
      return
    end

    case event.type
    when 'checkout.session.completed'
      session = event.data.object

      ApplicationRecord.transaction do
        order = create_order(session)
        session_with_expand = Stripe::Checkout::Session.retrieve({ id: session.id, expand: ['line_items'] })
        session_with_expand.line_items.data.each do |line_item|
          create_order_details(order, line_item)
        end
      end

      if guest_order?(session)
        # ゲスト注文: セッションカートはsuccessページでクリア
      else
        customer = Customer.find(session.client_reference_id)
        customer.cart_items.destroy_all if customer
      end

      OrderMailer.complete(email: session.customer_details.email).deliver_now
      redirect_to session.success_url
    end
  end

  private

  def guest_order?(session)
    session.client_reference_id == 'guest'
  end

  def create_order(session)
    Order.create!(
      customer_id: guest_order?(session) ? nil : session.client_reference_id,
      guest_email: guest_order?(session) ? session.customer_details.email : nil,
      name: session.shipping_details.name,
      postal_code: session.shipping_details.address.postal_code,
      prefecture: session.shipping_details.address.state,
      address1: session.shipping_details.address.line1,
      address2: session.shipping_details.address.line2,
      postage: session.shipping_options[0].shipping_amount,
      billing_amount: session.amount_total,
      status: 'confirm_payment'
    )
  end

  def create_order_details(order, line_item)
    product = Stripe::Product.retrieve(line_item.price.product)
    purchased_product = Product.find(product.metadata.product_id)
    raise ActiveRecord::RecordNotFound if purchased_product.nil?

    order.order_details.create!(
      product_id: purchased_product.id,
      price: line_item.price.unit_amount,
      quantity: line_item.quantity
    )
    purchased_product.update!(stock: (purchased_product.stock - line_item.quantity))
  end
end
