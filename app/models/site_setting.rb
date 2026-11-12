class SiteSetting < ApplicationRecord
  validates :key, presence: true, uniqueness: true

  def self.get(key, default = nil)
    find_by(key: key.to_s)&.typed_value || default
  end

  def self.set(key, value, value_type: "string")
    record = find_or_initialize_by(key: key.to_s)
    record.value_type = value_type
    record.value = value.is_a?(String) ? value : value.to_json
    record.save!
    record
  end

  def typed_value
    case value_type
    when "integer" then value.to_i
    when "float" then value.to_f
    when "boolean" then ActiveModel::Type::Boolean.new.cast(value)
    when "json" then JSON.parse(value)
    else value
    end
  rescue JSON::ParserError
    value
  end
end
