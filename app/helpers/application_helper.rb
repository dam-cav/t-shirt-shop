# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def display_price(price_cents)
    ActiveSupport::NumberHelper.number_to_currency(price_cents, unit: '€')
  end
end
