# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :set_order, only: %i[show confirm cancel]
  after_action :verify_authorized

  # GET /orders or /orders.json
  def index
    authorize Order, :index?

    orders = if current_user.seller?
               Order.all
                    .order(created_at: :desc)
             else
               Order.where(user_id: current_user.id)
                    .order(created_at: :desc)
             end

    @pagy, @orders = pagy(orders)

    @order_index_table_rows = %w[
      id
      user_email
      confirmed_at
      canceled_at
      created_at
      total_quantity
      total_price
    ].compact
  end

  # GET /orders/1 or /orders/1.json
  def show
    authorize @order, :show?
  end

  # POST /orders or /orders.json
  def create
    authorize Order, :create?
    result = VerifiedOrderGeneratorService.new(current_user:).run

    if result[:success] && result[:order]&.persisted?
      redirect_to order_url(result[:order]), notice: 'Order was successfully created.'
    else
      redirect_to cart_show_url, status: :unprocessable_entity, alert: result[:message]
    end
  end

  def confirm
    authorize @order, :confirm?

    @order.update(confirmed_at: Time.current)

    redirect_to order_url(@order), notice: 'Order was successfully confirmed.'
  end

  def cancel
    authorize @order, :cancel?

    order_user = @order.user
    ActiveRecord::Base.transaction do
      @order.update(canceled_at: Time.current)
      order_user.update!(wallet_money: order_user.wallet_money + @order.total_price)
    end

    redirect_to order_url(@order), notice: 'Order was successfully canceled.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end
end
