class UserPolicy < ApplicationPolicy
  def index?
    user&.super_admin?
  end

  def create?
    user&.super_admin?
  end

  def update?
    user&.super_admin?
  end

  def destroy?
    user&.super_admin? && record != user
  end
end
