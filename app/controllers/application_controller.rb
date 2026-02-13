class ApplicationController < ActionController::Base
  include GuestCartSupport
  helper_method :current_cart_quantity

  if ENV.fetch('BASIC_AUTH_ENABLED', 'false') == 'true'
    http_basic_authenticate_with(
      name: ENV.fetch('BASIC_AUTH_USERNAME', 'admin'),
      password: ENV.fetch('BASIC_AUTH_PASSWORD', 'password'),
      unless: ->(controller) { controller.controller_path == 'customer/webhooks' }
    )
  end

  def current_cart_quantity
    if customer_signed_in?
      current_customer.cart_items.sum(:quantity)
    else
      guest_cart_quantity
    end
  end
end
