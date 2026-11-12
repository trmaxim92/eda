class CityCourierPagesController < ApplicationController
  def show
    @city = City.published.find_by!(slug: params[:city_slug])
    @page = @city.city_courier_pages.published.find_by!(slug: params[:courier_type_slug])
    raise ActiveRecord::RecordNotFound unless @page.indexable?

    @courier_type = @page.courier_type
    @referral_link = current_referral_link(city: @city, courier_type: @courier_type)
    @faqs = Array(@page.faq_items)
    set_seo_meta(
      @page,
      robots: @page.indexable? ? (@page.robots_meta.presence || "index,follow") : "noindex,follow"
    )
  end
end
