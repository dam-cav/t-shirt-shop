# == Schema Information
#
# Table name: user_cart_t_shirts
#
#  id         :bigint           not null, primary key
#  quantity   :integer          default(1), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  t_shirt_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_user_cart_t_shirts_on_t_shirt_id  (t_shirt_id)
#  index_user_cart_t_shirts_on_user_id     (user_id)
#
class UserCartTShirt < ApplicationRecord
  belongs_to :user
  belongs_to :t_shirt
end
