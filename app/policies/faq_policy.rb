class FaqPolicy < ApplicationPolicy
  def index?
    content_access?
  end

  def create?
    content_access?
  end

  def update?
    content_access?
  end

  def destroy?
    adminish?
  end
end
