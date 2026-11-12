class City < ApplicationRecord
  has_many :referral_links, dependent: :nullify
  has_many :leads, dependent: :nullify
  has_many :reviews, dependent: :nullify
  has_many :referral_clicks, dependent: :nullify
  has_one_attached :og_image

  validates :name, :slug, presence: true
  validates :slug, uniqueness: true
  validate :publishable_content, if: :published?

  scope :published, -> { where(published: true) }
  scope :available, -> { where(connection_available: true) }
  scope :ordered, -> { order(:name) }

  before_validation :generate_slug, if: -> { slug.blank? && name.present? }

  def to_param
    slug
  end

  def indexable?
    published? && connection_available? && unique_text.to_s.strip.length >= 200
  end

  private

  def generate_slug
    self.slug = name.parameterize(locale: :ru)
  end

  def publishable_content
    unless connection_available?
      errors.add(:published, "можно публиковать только при доступном подключении")
    end

    if unique_text.to_s.strip.length < 200
      errors.add(:unique_text, "должен быть достаточно уникальным (минимум 200 символов)")
    end
  end
end
