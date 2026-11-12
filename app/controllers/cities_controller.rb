class CitiesController < ApplicationController
  def index
    @cities = City.published.available.ordered
    @page = Page.find_by(page_type: "cities_index", published: true)
    set_seo_meta(@page, title: @page&.seo_title || "Города — работа курьером", h1: @page&.h1 || "Города")
  end

  def show
    @city = City.published.find_by!(slug: params[:slug])
    raise ActiveRecord::RecordNotFound unless @city.indexable?

    @courier_types = CourierType.published.ordered
    @referral_link = current_referral_link(city: @city)
    @faqs = Array(@city.faq_items)
    set_seo_meta(
      @city,
      robots: @city.indexable? ? (@city.robots_meta.presence || "index,follow") : "noindex,follow"
    )
  end
end
