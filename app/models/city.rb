class City < ApplicationRecord
  has_many :referral_links, dependent: :nullify
  has_many :leads, dependent: :nullify
  has_many :reviews, dependent: :nullify
  has_many :referral_clicks, dependent: :nullify
  has_many :city_courier_types, dependent: :destroy
  has_many :courier_types, through: :city_courier_types
  has_many :available_city_courier_types, -> { available }, class_name: "CityCourierType"
  has_many :available_courier_types, through: :available_city_courier_types, source: :courier_type
  has_many :city_courier_pages, dependent: :destroy
  has_one_attached :og_image

  attr_accessor :skip_slug_redirect

  validates :name, :slug, presence: true
  validates :slug, uniqueness: true
  validates :sort_order, numericality: { only_integer: true }
  validate :publishable_content, if: :published?

  scope :published, -> { where(published: true) }
  scope :available, -> { where(connection_available: true) }
  # Align with #indexable? so sitemap/listings never expose cities that 404 on show.
  scope :indexable, lambda {
    published.available.where(is_indexable: true)
      .where.not(seo_title: [ nil, "" ])
      .where.not(h1: [ nil, "" ])
      .where("length(btrim(coalesce(unique_text, ''))) >= 200")
  }
  scope :featured, -> { where(is_featured: true) }
  scope :ordered, -> { order(:sort_order, :name) }

  before_validation :generate_slug, if: -> { slug.blank? && name.present? }
  before_validation :ensure_prepositional
  before_save :touch_content_updated_at, if: :content_fields_changed?
  after_update :create_slug_redirect, if: :saved_change_to_slug?

  def to_param
    slug
  end

  # Full phrase for templates: "в Уфе"
  def name_prepositional
    name_in_prepositional.presence || "в городе #{name}"
  end

  def name_genitive_form
    name_genitive.presence || name
  end

  def name_dative_form
    name_dative.presence || name
  end

  def declensions_complete?
    name_in_prepositional.present? && name_genitive.present? && name_dative.present?
  end

  def indexable?
    published? &&
      connection_available? &&
      is_indexable? &&
      unique_text.to_s.strip.length >= 200 &&
      seo_title.present? &&
      h1.present?
  end

  def readiness_score
    checks = [
      connection_available?,
      unique_text.to_s.strip.length >= 200,
      seo_title.present?,
      seo_description.present?,
      h1.present?,
      declensions_complete?,
      available_courier_types.exists?
    ]
    ((checks.count(true).to_f / checks.size) * 100).round
  end

  def sync_courier_type_availability!(availability_hash)
    values = availability_hash.to_h.transform_keys(&:to_s)
    CourierType.find_each do |type|
      join = city_courier_types.find_or_initialize_by(courier_type_id: type.id)
      join.available = ActiveModel::Type::Boolean.new.cast(values.fetch(type.id.to_s, false))
      join.save!
    end
  end

  private

  def generate_slug
    self.slug = name.parameterize(locale: :ru)
  end

  def ensure_prepositional
    return if name_in_prepositional.present? || name.blank?

    self.name_in_prepositional = "в городе #{name}"
  end

  def content_fields_changed?
    will_save_change_to_unique_text? ||
      will_save_change_to_short_description? ||
      will_save_change_to_delivery_methods? ||
      will_save_change_to_connection_conditions? ||
      will_save_change_to_work_features? ||
      will_save_change_to_faq_items?
  end

  def touch_content_updated_at
    self.content_updated_at = Time.current
  end

  def publishable_content
    unless connection_available?
      errors.add(:published, "можно публиковать только при доступном подключении")
    end

    if unique_text.to_s.strip.length < 200
      errors.add(:unique_text, "должен быть достаточно уникальным (минимум 200 символов)")
    end
  end

  def create_slug_redirect
    return if skip_slug_redirect
    old_slug, new_slug = saved_change_to_slug
    return if old_slug.blank? || new_slug.blank? || old_slug == new_slug

    Redirect.find_or_initialize_by(source_path: "/goroda/#{old_slug}").tap do |redirect|
      redirect.target_path = "/goroda/#{new_slug}/"
      redirect.redirect_type = 301
      redirect.active = true
      redirect.save!
    end
  end
end
