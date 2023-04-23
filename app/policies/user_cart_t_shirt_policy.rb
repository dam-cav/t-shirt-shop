# frozen_string_literal: true

class UserCartTShirtPolicy < ApplicationPolicy
  def update_cart_quantity?
    if record.instance_of? UserCartTShirt
      # it's a specific UserCartTShirt
      user.present? && record.user_id == user.id
    else
      # it's generically the class UserCartTShirt
      user.present?
    end
  end
end
