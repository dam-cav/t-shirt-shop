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

  def confirm?
    user.present? && user.seller? && !record.completed?
  end

  def cancel?
    user.present? && user.seller? && !record.completed?
  end
end
