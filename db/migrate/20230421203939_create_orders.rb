# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false
      t.datetime :confirmed_at
      t.datetime :canceled_at

      t.timestamps
    end
  end
end
