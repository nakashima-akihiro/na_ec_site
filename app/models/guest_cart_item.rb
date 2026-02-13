# frozen_string_literal: true

# ゲスト用の仮想カートアイテム（セッションから構築）
# ルート生成用にidはproduct_idを返す
class GuestCartItem
  attr_reader :product_id, :quantity

  def initialize(product_id:, quantity:)
    @product_id = product_id.to_i
    @quantity = quantity.to_i
  end

  def id
    product_id
  end

  def product
    @product ||= Product.find(product_id)
  end

  def line_total
    product.price * quantity
  end
end
