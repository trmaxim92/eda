class Page < ApplicationRecord
  PAGE_TYPES = %w[home content courier_type conditions park reviews contacts cities_index blog_index].freeze
  BLOCK_TYPES = %w[
    hero heading text image advantages list steps reviews faq cta lead_form income_calculator related_links
  ].freeze

  has_one_attached :og_image
  has_one_attached :cover_image

  validates :title, :slug, :page_type, presence: true
  validates :slug, uniqueness: true
  validates :page_type, inclusion: { in: PAGE_TYPES }

  scope :published, -> { where(published: true) }
  scope :ordered, -> { order(:position, :title) }

  before_validation :generate_slug, if: -> { slug.blank? && title.present? }
  before_save :set_published_at

  def to_param
    slug
  end

  def enabled_blocks
    Array(blocks).select { |block| block["enabled"] != false }
                 .sort_by { |block| block["position"].to_i }
  end

  private

  def generate_slug
    self.slug = title.parameterize(locale: :ru)
  end

  def set_published_at
    self.published_at = Time.current if published? && published_at.blank?
  end
end
