class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    user.present?
  end

  def show?
    user.present?
  end

  def create?
    adminish?
  end

  def new?
    create?
  end

  def update?
    adminish?
  end

  def edit?
    update?
  end

  def destroy?
    user&.super_admin? || user&.admin?
  end

  private

  def adminish?
    user&.super_admin? || user&.admin?
  end

  def content_access?
    user&.can_manage_content?
  end

  def leads_access?
    user&.can_manage_leads?
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end

    private

    attr_reader :user, :scope
  end
end
