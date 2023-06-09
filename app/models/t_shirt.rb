# frozen_string_literal: true

# == Schema Information
#
# Table name: t_shirts
#
#  id         :bigint           not null, primary key
#  brand      :string(255)
#  color      :string(255)
#  name       :string(255)      not null
#  price      :integer          not null
#  quantity   :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class TShirt < ApplicationRecord
  validates :name, :price, :quantity, presence: true

  has_many :user_cart_t_shirts, dependent: :destroy

  # out of stock products go to the bottom even if more recent
  scope :catalog_sort, lambda {
    order(Arel.sql('case when quantity = 0 then 1 else 0 end'))
      .order(created_at: :desc)
  }

  def self.ransackable_attributes(_auth_object = nil)
    %w[brand color price]
  end

  def euro_price
    price.to_f / 100
  end
end
