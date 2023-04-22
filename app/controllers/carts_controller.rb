# frozen_string_literal: true

class CartsController < ApplicationController
  def show
    @user_cart_t_shirts = UserCartTShirt.includes(:t_shirt)
                                        .where(user_id: current_user.id)

    @total = @user_cart_t_shirts.sum { |cart_shirt| cart_shirt.quantity * cart_shirt.t_shirt.price }

    # anticipate future order errors
    @warnings = []

    invalid_quantities_in_cart = VerifiedOrderGeneratorService.invalid_quantities_in_cart_count(
      current_user:,
      t_shirt_ids: @user_cart_t_shirts.pluck(:t_shirt_id)
    ).positive?
    @warnings << 'invalid_quantities_in_cart' if invalid_quantities_in_cart

    not_enough_money = current_user.wallet_money < @total
    @warnings << 'not_enough_money' if not_enough_money
  end
end
