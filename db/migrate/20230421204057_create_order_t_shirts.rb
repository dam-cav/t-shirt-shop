# frozen_string_literal: true

class CreateOrderTShirts < ActiveRecord::Migration[7.0]
  def change
    create_table :order_t_shirts do |t|
      t.references :order, null: false
      t.references :t_shirt, null: false
      t.integer :quantity, null: false
      t.integer :final_price

      t.timestamps
    end
  end
end
