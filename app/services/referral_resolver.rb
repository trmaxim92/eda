class ReferralResolver
  def initialize(city: nil, courier_type: nil)
    @city = city
    @courier_type = courier_type
  end

  def call
    scope = ReferralLink.active.ordered

    if city_id && courier_type_id
      link = scope.find_by(city_id: city_id, courier_type_id: courier_type_id)
      return link if link
    end

    if city_id
      link = scope.where(courier_type_id: nil).find_by(city_id: city_id)
      return link if link
    end

    if courier_type_id
      link = scope.where(city_id: nil).find_by(courier_type_id: courier_type_id)
      return link if link
    end

    scope.find_by(is_default: true) || scope.where(city_id: nil, courier_type_id: nil).first
  end

  private

  attr_reader :city, :courier_type

  def city_id
    city&.id
  end

  def courier_type_id
    courier_type&.id
  end
end
