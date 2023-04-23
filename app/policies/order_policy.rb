# frozen_string_literal: true

class OrderPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    user.present? && (user.seller? || record.user_id == user.id)
  end

  def create?
    user.present?
  end
end
