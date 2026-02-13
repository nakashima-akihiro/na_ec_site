class Customer::CheckoutsController < ApplicationController
  def create
    line_items = build_line_items
    return redirect_to cart_items_path, alert: 'カートが空です' if line_items.blank?

    session_stripe = create_stripe_session(line_items)
    redirect_to session_stripe.url, allow_other_host: true
  end

  private

  def build_line_items
    if customer_signed_in?
      current_customer.line_items_checkout
    else
      guest_cart_items.map do |item|
        {
          quantity: item.quantity,
          price_data: {
            currency: 'jpy',
            unit_amount: item.product.price,
            product_data: {
              name: item.product.name,
              metadata: {
                product_id: item.product.id
              }
            }
          }
        }
      end
    end
  end

  def create_stripe_session(line_items)
    total = customer_signed_in? ? current_customer.cart_items.inject(0) { |sum, ci| sum + ci.line_total } : guest_cart_items.sum(&:line_total)
    shipping_fee = total >= SiteSetting.free_shipping_threshold ? 0 : SiteSetting.postage
    client_reference_id = customer_signed_in? ? current_customer.id : 'guest'
    customer_email = customer_signed_in? ? current_customer.email : nil

    Stripe::Checkout::Session.create(
      client_reference_id: client_reference_id.to_s,
      customer_email: customer_email,
      mode: 'payment',
      payment_method_types: ['card'],
      line_items: line_items,
      shipping_address_collection: {
        allowed_countries: ['JP']
      },
      shipping_options: [
        {
          shipping_rate_data: {
            type: 'fixed_amount',
            fixed_amount: {
              amount: shipping_fee,
              currency: 'jpy'
            },
            display_name: 'Single rate'
          }
        }
      ],
      success_url: "#{root_url}orders/success",
      cancel_url: "#{root_url}cart_items"
    )
  end
end
