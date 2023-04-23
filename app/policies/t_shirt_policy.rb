# frozen_string_literal: true

class TShirtPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def new?
    user.present? && user.seller?
  end

  def edit?
    user.present? && user.seller?
  end

  def create?
    user.present? && user.seller?
  end

  def update?
    user.present? && user.seller?
  end

  def destroy?
    user.present? && user.seller?
  end
end
