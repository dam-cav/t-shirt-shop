# frozen_string_literal: true

class CartPolicy < ApplicationPolicy
  # headless policy
  def initialize(user, record = nil)
    super(user, record)
  end

  def show?
    user.present?
  end
end
