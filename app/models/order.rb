# frozen_string_literal: true

# == Schema Information
#
# Table name: orders
#
#  id           :bigint           not null, primary key
#  canceled_at  :datetime
#  confirmed_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_orders_on_user_id  (user_id)
#
class Order < ApplicationRecord
  belongs_to :user
  has_many :order_t_shirts, dependent: :destroy

  def total_quantity
    order_t_shirts.sum(&:quantity)
  end

  def total_price
    order_t_shirts.sum { |o_t_s| o_t_s.final_price * o_t_s.quantity }
  end

  def completed?
    canceled_at? || confirmed_at?
  end
end
