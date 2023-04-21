# frozen_string_literal: true

class CartsController < ApplicationController
  def show
    @user_cart_t_shirts = UserCartTShirt.includes(:t_shirt)
                                        .where(user_id: current_user.id)

    @total = @user_cart_t_shirts.sum { |cart_shirt| cart_shirt.quantity * cart_shirt.t_shirt.price }
  end
end
