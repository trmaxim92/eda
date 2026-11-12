class HomeController < ApplicationController
  def index
    @courier_types = CourierType.published.ordered
    @cities = City.indexable.ordered
    @featured_cities = City.indexable.featured.ordered.presence || @cities.limit(8)
    @reviews = Review.published.ordered.limit(6)
    @faqs = Faq.published.for_scope("home").ordered
    @page = Page.find_by(page_type: "home", published: true)
    @selected_city_types = selected_city&.available_courier_types&.merge(CourierType.published)&.ordered || CourierType.none
    @selected_city_referral = selected_city ? current_referral_link(city: selected_city) : current_referral_link
    set_seo_meta(
      @page,
      title: @page&.seo_title.presence || "Работа курьером в Яндекс Еде",
      description: @page&.seo_description.presence || "Подключение пеших, вело- и автокурьеров к Яндекс Еде. Выберите город, оставьте заявку или зарегистрируйтесь самостоятельно.",
      h1: @page&.h1.presence || "Работа курьером в Яндекс Еде"
    )
  end
end
