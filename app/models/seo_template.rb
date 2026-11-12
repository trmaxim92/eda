class SeoTemplate < ApplicationRecord
  SCOPES = %w[city courier_type city_courier].freeze

  validates :scope, :name, :title_template, :description_template, :h1_template, presence: true
  validates :scope, inclusion: { in: SCOPES }

  scope :active, -> { where(active: true) }
  scope :for_scope, ->(scope) { where(scope: scope) }

  def apply_to(record, city: nil, courier_type: nil, overwrite: false)
    city ||= record.try(:city)
    courier_type ||= record.try(:courier_type)
    vars = {
      "city" => city&.name.to_s,
      "city_prep" => city&.name_prepositional.to_s,
      "courier_type" => courier_type&.name.to_s.downcase
    }

    assign_if_allowed(record, :seo_title, render(title_template, vars), overwrite)
    assign_if_allowed(record, :seo_description, render(description_template, vars), overwrite)
    h1_attr = record.respond_to?(:h1) ? :h1 : :seo_h1
    assign_if_allowed(record, h1_attr, render(h1_template, vars), overwrite)
    record
  end

  def preview(city: nil, courier_type: nil)
    vars = {
      "city" => city&.name.to_s.presence || "Уфа",
      "city_prep" => city&.name_prepositional.to_s.presence || "в Уфе",
      "courier_type" => courier_type&.name.to_s.downcase.presence || "пешим"
    }
    {
      title: render(title_template, vars),
      description: render(description_template, vars),
      h1: render(h1_template, vars),
      warnings: length_warnings(vars)
    }
  end

  private

  def render(template, vars)
    template.to_s.gsub(/\{(\w+)\}/) { vars[$1] || "" }.squish
  end

  def assign_if_allowed(record, attr, value, overwrite)
    return unless record.respond_to?("#{attr}=")
    current = record.public_send(attr)
    return if current.present? && !overwrite

    record.public_send("#{attr}=", value)
  end

  def length_warnings(vars)
    title = render(title_template, vars)
    description = render(description_template, vars)
    warnings = []
    warnings << "Title длиннее 70 символов (#{title.length})" if title.length > 70
    warnings << "Description длиннее 160 символов (#{description.length})" if description.length > 160
    warnings
  end
end
