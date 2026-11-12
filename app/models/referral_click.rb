class ReferralClick < ApplicationRecord
  belongs_to :referral_link
  belongs_to :city, optional: true
  belongs_to :courier_type, optional: true

  validates :clicked_at, presence: true

  scope :today, -> { where(clicked_at: Time.zone.now.beginning_of_day..) }
  scope :this_week, -> { where(clicked_at: 7.days.ago..) }
  scope :this_month, -> { where(clicked_at: 30.days.ago..) }
end
