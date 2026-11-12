class Faq < ApplicationRecord
  validates :question, :answer, presence: true

  scope :published, -> { where(published: true) }
  scope :for_scope, ->(scope) { where(page_scope: scope) }
  scope :ordered, -> { order(:position, :id) }
end
