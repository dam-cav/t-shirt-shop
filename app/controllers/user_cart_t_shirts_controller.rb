# frozen_string_literal: true

class UserCartTShirtsController < ApplicationController
  def update_cart_quantity
    shirt_to_add_id = user_cart_t_shirt_params[:t_shirt_id]
    new_quantity = user_cart_t_shirt_params[:quantity]&.to_i

    user_cart_t_shirt = UserCartTShirt.find_by(user_id: current_user.id,
                                               t_shirt_id: shirt_to_add_id)

    if user_cart_t_shirt.present? && new_quantity.positive?
      user_cart_t_shirt.update(quantity: new_quantity)
    elsif user_cart_t_shirt.present?
      user_cart_t_shirt.destroy!
    elsif new_quantity.positive?
      UserCartTShirt.create!(user_id: current_user.id,
                                                 t_shirt_id: shirt_to_add_id,
                                                 quantity: new_quantity)
    end

    redirect_to cart_show_path
  end

  def user_cart_t_shirt_params
    params[:user_cart_t_shirt].permit(:t_shirt_id,
                                      :quantity)
  end
end
