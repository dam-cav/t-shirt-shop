# frozen_string_literal: true

class VerifiedOrderGeneratorService
  def initialize(current_user:)
    @current_user = current_user
  end

  def run
    success = false
    message = nil
    new_order = nil

    # prevent cuncurrent wallet_money update
    @current_user.with_lock do
      current_user_cart_t_shirt = UserCartTShirt.where(user_id: @current_user.id)

      user_cart_t_shirt_ids = current_user_cart_t_shirt.pluck(:t_shirt_id)
      # prevent cuncurrent quantity update
      TShirt.where(id: user_cart_t_shirt_ids).select('id').lock!.to_a

      raise 'nothing to buy' if current_user_cart_t_shirt.count < 1

      # check available quantities
      invalid_quantities_in_cart = VerifiedOrderGeneratorService.invalid_quantities_in_cart_count(
        current_user: @current_user,
        t_shirt_ids: user_cart_t_shirt_ids
      ).positive?
      raise 'the requested quantities are not available' if invalid_quantities_in_cart

      # calculate total and check availability of money
      total_price = current_user_cart_t_shirt.sum { |cart_shirt| cart_shirt.quantity * cart_shirt.t_shirt.price }
      raise 'you do not have enough money' if @current_user.wallet_money < total_price

      # create the order
      new_order = Order.create!(user_id: @current_user.id)
      current_user_cart_t_shirt.each do |cart_t_shirt|
        # add requested t_shirts to the order
        catalog_t_shirt = cart_t_shirt.t_shirt
        OrderTShirt.create!(order_id: new_order.id,
                            t_shirt_id: catalog_t_shirt.id,
                            final_price: catalog_t_shirt.price,
                            quantity: cart_t_shirt.quantity)

        # reduce available quantities in catalog
        catalog_t_shirt.update!(quantity: catalog_t_shirt.quantity - cart_t_shirt.quantity)
      end
      # remove money from the user wallet
      @current_user.update!(wallet_money: @current_user.wallet_money - total_price)
      # free the user cart
      current_user_cart_t_shirt.destroy_all

      success = true

    rescue StandardError => e
      Rails.logger.warn e.message

      new_order = nil
      success = false
      message = e.message

      # cancel everything
      raise ::ActiveRecord::Rollback
    end

    { success:, message:, order: new_order }
  end

  def self.invalid_quantities_in_cart_count(current_user:, t_shirt_ids:)
    UserCartTShirt.left_joins(:t_shirt)
                  .where(user_id: current_user.id, t_shirt_id: t_shirt_ids)
                  .where('user_cart_t_shirts.quantity > t_shirts.quantity')
                  .count
  end
end
