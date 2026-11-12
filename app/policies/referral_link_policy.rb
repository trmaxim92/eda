class ReferralLinkPolicy < ApplicationPolicy
  def index?
    adminish? || user&.manager?
  end

  def show?
    index?
  end

  def create?
    adminish?
  end

  def update?
    adminish?
  end

  def destroy?
    adminish?
  end
end
