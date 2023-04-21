# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def display_price(price)
    ActiveSupport::NumberHelper.number_to_currency(price, unit: '€')
  end

  def display_euro_price(price_cents)
    ActiveSupport::NumberHelper.number_to_currency(price_cents.to_f / 100, unit: '€')
  end
end
