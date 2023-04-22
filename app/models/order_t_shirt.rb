# frozen_string_literal: true

# == Schema Information
#
# Table name: order_t_shirts
#
#  id          :bigint           not null, primary key
#  final_price :integer
#  quantity    :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  order_id    :bigint           not null
#  t_shirt_id  :bigint           not null
#
# Indexes
#
#  index_order_t_shirts_on_order_id    (order_id)
#  index_order_t_shirts_on_t_shirt_id  (t_shirt_id)
#
class OrderTShirt < ApplicationRecord
  belongs_to :t_shirt
  belongs_to :order
end
