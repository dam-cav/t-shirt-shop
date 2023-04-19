# frozen_string_literal: true

module ApplicationHelper
  def display_price(price_cents)
    ActiveSupport::NumberHelper.number_to_currency(price_cents, unit: '€')
  end
end
