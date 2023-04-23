# frozen_string_literal: true

class AddSellerToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :seller, :boolean, null: false, default: false
  end
end
