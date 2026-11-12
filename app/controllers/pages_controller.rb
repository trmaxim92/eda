class PagesController < ApplicationController
  def show
    @page = Page.published.find_by!(slug: params[:slug])
    @courier_types = CourierType.published.ordered
    @cities = City.published.available.ordered
    @faqs = Faq.published.for_scope(@page.slug).or(Faq.published.for_scope("home")).ordered.limit(12)
    @reviews = Review.published.ordered.limit(6) if @page.page_type.in?(%w[reviews content])
    set_seo_meta(@page)
  end
end
