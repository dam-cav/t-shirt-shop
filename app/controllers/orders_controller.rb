# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :set_order, only: %i[show]

  # GET /orders or /orders.json
  def index
    @orders = Order.where(user_id: current_user.id)
  end

  # GET /orders/1 or /orders/1.json
  def show; end

  # POST /orders or /orders.json
  def create
    result = VerifiedOrderGeneratorService.new(current_user:).run

    if result[:success] && result[:order]&.persisted?
      redirect_to order_url(result[:order]), notice: 'Order was successfully created.'
    else
      redirect_to cart_show_url, status: :unprocessable_entity, alert: result[:message]
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end
end
