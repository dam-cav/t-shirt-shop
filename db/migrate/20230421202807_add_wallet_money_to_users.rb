# frozen_string_literal: true

class AddWalletMoneyToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :wallet_money, :integer, null: false, default: 0
  end
end
