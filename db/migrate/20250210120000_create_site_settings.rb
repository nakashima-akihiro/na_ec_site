# frozen_string_literal: true

class CreateSiteSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :site_settings do |t|
      t.integer :postage, default: 500, null: false
      t.integer :free_shipping_threshold, default: 5000, null: false

      t.timestamps
    end
  end
end
