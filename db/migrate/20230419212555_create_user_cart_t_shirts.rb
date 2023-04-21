# frozen_string_literal: true

class CreateUserCartTShirts < ActiveRecord::Migration[7.0]
  def change
    create_table :user_cart_t_shirts do |t|
      t.references :user, null: false
      t.references :t_shirt, null: false
      t.integer :quantity, null: false, default: 1

      t.timestamps
    end
  end
end
