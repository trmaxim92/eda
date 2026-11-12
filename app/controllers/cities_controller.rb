class CitiesController < ApplicationController
  def index
    @cities = City.indexable.ordered
    @cities_by_region = @cities.group_by { |city| city.region.to_s.strip }
    @page = Page.find_by(page_type: "cities_index", published: true)
    set_seo_meta(
      @page,
      title: @page&.seo_title.presence || "Города, в которых можно работать курьером в Яндекс Еде",
      description: @page&.seo_description.presence || "Список городов с доступным подключением курьеров к Яндекс Еде. Выберите город и оставьте заявку.",
      h1: @page&.h1.presence || "Города, в которых можно работать курьером"
    )
  end

  def show
    @city = City.published.find_by!(slug: params[:slug])
    raise ActiveRecord::RecordNotFound unless @city.indexable?

    @courier_types = @city.available_courier_types.merge(CourierType.published).ordered
    @city_courier_pages = @city.city_courier_pages.indexable.includes(:courier_type)
    @referral_link = current_referral_link(city: @city)
    @faqs = Array(@city.faq_items)
    set_seo_meta(
      @city,
      robots: @city.indexable? ? (@city.robots_meta.presence || "index,follow") : "noindex,follow"
    )
  end
end
