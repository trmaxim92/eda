class CourierType < ApplicationRecord
  CODES = {
    pedestrian: "pedestrian",
    bike: "bike",
    auto: "auto"
  }.freeze

  has_many :referral_links, dependent: :nullify
  has_many :leads, dependent: :nullify
  has_many :reviews, dependent: :nullify
  has_many :referral_clicks, dependent: :nullify
  has_one_attached :og_image

  validates :name, :slug, :code, presence: true
  validates :slug, :code, uniqueness: true

  scope :published, -> { where(published: true) }
  scope :ordered, -> { order(:position, :name) }

  before_validation :generate_slug, if: -> { slug.blank? && name.present? }

  def to_param
    slug
  end

  private

  def generate_slug
    self.slug = name.parameterize(locale: :ru)
  end
end
