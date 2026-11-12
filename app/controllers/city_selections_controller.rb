class CitySelectionsController < ApplicationController
  def create
    city = City.indexable.find_by(slug: params[:city_slug].presence)
    if city.blank? && params[:city_name].present?
      name = params[:city_name].to_s.strip
      city = City.indexable.where("lower(name) = ?", name.downcase).first
    end
    city ||= City.published.available.find_by(id: params[:city_id])

    if city
      session[:selected_city_slug] = city.slug
      cookies.permanent[:selected_city_slug] = city.slug
      redirect_back fallback_location: root_path, notice: "Выбран город: #{city.name}"
    else
      redirect_back fallback_location: root_path, alert: "Город недоступен"
    end
  end

  def destroy
    session.delete(:selected_city_slug)
    cookies.delete(:selected_city_slug)
    redirect_back fallback_location: root_path, notice: "Выбор города сброшен"
  end
end
