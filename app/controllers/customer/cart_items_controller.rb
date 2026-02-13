class Customer::CartItemsController < ApplicationController
  before_action :set_cart_item, only: %i[increase decrease destroy]

  def index
    if customer_signed_in?
      @cart_items = current_customer.cart_items
    else
      @cart_items = guest_cart_items
    end
    @total = @cart_items.is_a?(ActiveRecord::Relation) ? @cart_items.inject(0) { |sum, ci| sum + ci.line_total } : @cart_items.sum(&:line_total)
    @shipping_fee = @total >= SiteSetting.free_shipping_threshold ? 0 : SiteSetting.postage
  end

  def create
    if customer_signed_in?
      increase_or_create_customer(params[:cart_item][:product_id])
      redirect_to cart_items_path, notice: 'カートに追加しました'
    else
      add_to_guest_cart(params[:cart_item][:product_id])
      redirect_to cart_items_path, notice: 'カートに追加しました'
    end
  end

  def increase
    if customer_signed_in?
      @cart_item.increment!(:quantity, 1)
      redirect_to request.referer, notice: 'カートを更新しました'
    else
      add_to_guest_cart(@cart_item.product_id.to_s)
      redirect_to request.referer, notice: 'カートを更新しました'
    end
  end

  def decrease
    if customer_signed_in?
      decrease_or_destroy(@cart_item)
      redirect_to request.referer, notice: 'カートを更新しました'
    else
      remove_from_guest_cart(@cart_item.product_id.to_s)
      redirect_to request.referer, notice: 'カートを更新しました'
    end
  end

  def destroy
    if customer_signed_in?
      @cart_item.destroy
      redirect_to request.referer, notice: 'カートから削除しました'
    else
      guest_cart.delete(@cart_item.product_id.to_s)
      redirect_to request.referer, notice: 'カートから削除しました'
    end
  end

  private

  def set_cart_item
    if customer_signed_in?
      @cart_item = current_customer.cart_items.find(params[:id])
    else
      product_id = params[:id]
      qty = guest_cart[product_id.to_s].to_i
      raise ActiveRecord::RecordNotFound if qty.zero?

      @cart_item = GuestCartItem.new(product_id: product_id, quantity: qty)
    end
  end

  def increase_or_create_customer(product_id)
    cart_item = current_customer.cart_items.find_by(product_id: product_id)
    if cart_item
      cart_item.increment!(:quantity, 1)
    else
      current_customer.cart_items.create!(product_id: product_id)
    end
  end

  def add_to_guest_cart(product_id)
    key = product_id.to_s
    guest_cart[key] = guest_cart[key].to_i + 1
  end

  def remove_from_guest_cart(product_id)
    key = product_id.to_s
    return if guest_cart[key].to_i <= 0

    guest_cart[key] -= 1
    guest_cart.delete(key) if guest_cart[key] <= 0
  end

  def decrease_or_destroy(cart_item)
    if cart_item.quantity > 1
      cart_item.decrement!(:quantity, 1)
    else
      cart_item.destroy
    end
  end
end
