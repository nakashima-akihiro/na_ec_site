# frozen_string_literal: true

class AddGuestSupportToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :guest_email, :string
    change_column_null :orders, :customer_id, true
  end
end
