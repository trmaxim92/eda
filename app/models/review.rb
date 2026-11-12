class Review < ApplicationRecord
  belongs_to :city, optional: true
  belongs_to :courier_type, optional: true
  has_one_attached :photo

  validates :author_name, :body, presence: true

  scope :published, -> { where(published: true, moderated: true) }
  scope :ordered, -> { order(:position, created_at: :desc) }
end
