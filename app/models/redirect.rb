class Redirect < ApplicationRecord
  validates :source_path, :target_path, :redirect_type, presence: true
  validates :source_path, uniqueness: true
  validates :redirect_type, inclusion: { in: [ 301, 302 ] }
  validate :no_self_redirect
  validate :no_simple_cycle

  scope :active, -> { where(active: true) }

  def status_code
    redirect_type
  end

  private

  def no_self_redirect
    return if source_path.blank? || target_path.blank?
    errors.add(:target_path, "не может совпадать с исходным") if normalize(source_path) == normalize(target_path)
  end

  def no_simple_cycle
    return if source_path.blank? || target_path.blank?

    reverse = self.class.find_by(source_path: normalize(target_path), active: true)
    return unless reverse && normalize(reverse.target_path) == normalize(source_path)

    errors.add(:target_path, "создаёт циклический редирект")
  end

  def normalize(path)
    path.to_s.strip.downcase.chomp("/")
  end
end
