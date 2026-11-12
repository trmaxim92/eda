module SelectedCity
  extend ActiveSupport::Concern

  included do
    helper_method :selected_city
  end

  private

  def selected_city
    slug = session[:selected_city_slug].presence || cookies[:selected_city_slug].presence
    return if slug.blank?

    @selected_city ||= City.published.available.find_by(slug: slug)
  end
end
