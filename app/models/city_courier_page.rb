class CityCourierPage < ApplicationRecord
  belongs_to :city
  belongs_to :courier_type

  validates :slug, presence: true
  validates :slug, uniqueness: { scope: :city_id }
  validates :courier_type_id, uniqueness: { scope: :city_id }
  validate :publishable_content, if: :published?

  scope :published, -> { where(published: true) }
  scope :indexable, -> { where(is_indexable: true, published: true) }

  before_validation :generate_slug, if: -> { slug.blank? && courier_type.present? }

  def indexable?
    published? && is_indexable? && city.indexable? && city_type_available?
  end

  def public_path
    "/goroda/#{city.slug}/#{slug}/"
  end

  def readiness_score
    checks = [
      unique_text.to_s.strip.length >= 200,
      seo_title.present?,
      seo_description.present?,
      h1.present?,
      city_type_available?
    ]
    ((checks.count(true).to_f / checks.size) * 100).round
  end

  private

  def city_type_available?
    CityCourierType.exists?(city_id: city_id, courier_type_id: courier_type_id, available: true)
  end

  def generate_slug
    self.slug = {
      "pedestrian" => "peshiy-kurer",
      "bike" => "velokurer",
      "auto" => "avtokurer"
    }[courier_type.code] || courier_type.code
  end

  def publishable_content
    if unique_text.to_s.strip.length < 200
      errors.add(:unique_text, "должен быть достаточно уникальным (минимум 200 символов)")
    end
    unless city_type_available?
      errors.add(:base, "тип доставки должен быть доступен в городе")
    end
  end
end
