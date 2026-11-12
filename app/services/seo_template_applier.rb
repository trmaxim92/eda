class SeoTemplateApplier
  def self.apply(record, scope:, overwrite: false)
    template = SeoTemplate.active.for_scope(scope).order(:id).first
    return record unless template

    city = record.is_a?(City) ? record : record.try(:city)
    courier_type = record.is_a?(CourierType) ? record : record.try(:courier_type)
    template.apply_to(record, city: city, courier_type: courier_type, overwrite: overwrite)
  end
end
