class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  enum :role, {
    super_admin: 0,
    admin: 1,
    content_manager: 2,
    manager: 3
  }, default: :manager

  validates :name, presence: true
  validates :role, presence: true

  scope :active, -> { where(active: true) }

  def admin_access?
    super_admin? || admin?
  end

  def can_manage_content?
    super_admin? || admin? || content_manager?
  end

  def can_manage_leads?
    super_admin? || admin? || manager?
  end
end
