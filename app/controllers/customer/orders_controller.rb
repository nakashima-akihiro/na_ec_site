class Customer::OrdersController < ApplicationController
  before_action :authenticate_customer!, except: [:success]

  def index
    @orders = current_customer.orders.latest
  end

  def show
    @order = current_customer.orders.find(params[:id])
  end

  def success
    clear_guest_cart
  end
end
