class Customer::ProductsController < ApplicationController
  def index
    products = Product.all
    if params[:category_id].present?
      @category = Category.find(params[:category_id])
      products = @category.products
    end

    if params[:latest]
      @products = products.order(created_at: :desc)
      @sort = 'latest'
    elsif params[:price_high_to_low]
      @products = products.price_high_to_low
      @sort = 'price_high_to_low'
    elsif params[:price_low_to_high]
      @products = products.price_low_to_high
      @sort = 'price_low_to_high'
    else
      @products = products
      @sort = 'default'
    end
  end

  def show
    @product = Product.find(params[:id])
    @cart_item = CartItem.new
  end

  private

  def get_products(params)
    return Product.all, 'default' unless params[:latest] || params[:price_high_to_low] || params[:price_low_to_high]

    return Product.latest, 'latest' if params[:latest]

    return Product.price_high_to_low, 'price_high_to_low' if params[:price_high_to_low]

    return Product.price_low_to_high, 'price_low_to_high' if params[:price_low_to_high]
  end
end
