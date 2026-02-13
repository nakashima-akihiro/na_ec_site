# frozen_string_literal: true

module GuestCartSupport
  GUEST_CART_KEY = :guest_cart

  def guest_cart
    session[GUEST_CART_KEY] ||= {}
  end

  def guest_cart_items
    guest_cart.map do |product_id, quantity|
      GuestCartItem.new(product_id: product_id, quantity: quantity)
    end
  end

  def guest_cart_total
    guest_cart_items.sum(&:line_total)
  end

  def guest_cart_quantity
    guest_cart.values.sum
  end

  def clear_guest_cart
    session.delete(GUEST_CART_KEY)
  end
end
