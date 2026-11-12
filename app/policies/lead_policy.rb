class LeadPolicy < ApplicationPolicy
  def index?
    leads_access?
  end

  def show?
    leads_access?
  end

  def update?
    leads_access?
  end

  def create?
    false
  end

  def destroy?
    user&.super_admin? || user&.admin?
  end
end
