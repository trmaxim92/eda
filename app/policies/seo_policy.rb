class SeoPolicy < ApplicationPolicy
  def show?
    content_access?
  end
end
