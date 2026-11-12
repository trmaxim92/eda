class CityCourierType < ApplicationRecord
  belongs_to :city
  belongs_to :courier_type

  validates :city_id, uniqueness: { scope: :courier_type_id }

  scope :available, -> { where(available: true) }
end
