class ReferralLink < ApplicationRecord
  TRUSTED_HOST_SUFFIXES = %w[
    yandex.ru
    yandex.com
    ya.ru
    eda.yandex.ru
    park-dostavka.ru
  ].freeze

  belongs_to :city, optional: true
  belongs_to :courier_type, optional: true
  has_many :referral_clicks, dependent: :restrict_with_exception

  validates :name, :url, presence: true
  validates :priority, numericality: { only_integer: true }
  validate :url_must_be_trusted
  validate :only_one_default, if: :is_default?

  scope :active, -> { where(is_active: true) }
  scope :ordered, -> { order(priority: :desc, created_at: :desc) }

  before_save :unset_other_defaults, if: :is_default?

  def trusted_url?
    self.class.trusted_url?(url)
  end

  def self.trusted_url?(value)
    uri = URI.parse(value.to_s)
    return false unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
    return false if uri.host.blank?

    host = uri.host.downcase
    TRUSTED_HOST_SUFFIXES.any? { |suffix| host == suffix || host.end_with?(".#{suffix}") }
  rescue URI::InvalidURIError
    false
  end

  private

  def url_must_be_trusted
    errors.add(:url, "должен вести на доверенный домен") unless trusted_url?
  end

  def only_one_default
    return unless self.class.where(is_default: true).where.not(id: id).exists?

    # Soft rule handled in before_save; keep validation light.
  end

  def unset_other_defaults
    self.class.where.not(id: id).update_all(is_default: false)
  end
end
