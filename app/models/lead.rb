class Lead < ApplicationRecord
  belongs_to :city, optional: true
  belongs_to :courier_type, optional: true

  enum :status, {
    new_lead: 0,
    in_progress: 1,
    contacted: 2,
    connected: 3,
    rejected: 4,
    unreachable: 5,
    archived: 6
  }, default: :new_lead

  validates :name, :phone, presence: true
  validates :consent, acceptance: { accept: true }
  validates :phone, format: { with: /\A[\d\s\+\-\(\)]{10,20}\z/ }

  scope :recent, -> { order(created_at: :desc) }
  scope :today, -> { where(created_at: Time.zone.now.beginning_of_day..) }

  def status_label
    I18n.t("leads.statuses.#{status}", default: status.humanize)
  end
end
