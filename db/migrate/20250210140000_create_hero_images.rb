# frozen_string_literal: true

class CreateHeroImages < ActiveRecord::Migration[7.0]
  def change
    create_table :hero_images do |t|
      t.integer :position, null: false, default: 0

      t.timestamps
    end
  end
end
