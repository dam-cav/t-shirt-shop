# frozen_string_literal: true

class CreateTShirts < ActiveRecord::Migration[7.0]
  def change
    create_table :t_shirts do |t|
      t.string :name, null: false
      t.string :brand
      t.string :color

      t.integer :price, null: false # in cents
      t.integer :quantity, default: 0, null: false

      t.timestamps null: false
    end
  end
end
