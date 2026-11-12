class HomeController < ApplicationController
  def index
    @courier_types = CourierType.published.ordered
    @cities = City.indexable.ordered
    @reviews = Review.published.ordered.limit(6)
    @faqs = Faq.published.for_scope("home").ordered
    @page = Page.find_by(page_type: "home", published: true)
    @selected_city_types = selected_city&.available_courier_types&.merge(CourierType.published)&.ordered || CourierType.none
    @selected_city_referral = selected_city ? current_referral_link(city: selected_city) : current_referral_link
    set_seo_meta(
      @page,
      title: @page&.seo_title.presence || "Работа курьером в Яндекс Еде — Park Dostavka",
      description: @page&.seo_description.presence || "Подключение курьеров в Яндекс Еду через парк-партнёр park-dostavka.ru. Пешие, вело- и автокурьеры.",
      h1: @page&.h1.presence || "Работа курьером в Яндекс Еде"
    )
  end
end
