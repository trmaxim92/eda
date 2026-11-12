class SiteSettingPolicy < ApplicationPolicy
  def index?
    adminish?
  end

  def update?
    adminish?
  end
end
