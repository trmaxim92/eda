class RedirectPolicy < ApplicationPolicy
  def index?
    adminish?
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
