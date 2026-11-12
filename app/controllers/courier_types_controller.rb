class CourierTypesController < ApplicationController
  def show
    @courier_type = CourierType.published.find_by!(slug: params[:slug])
    @cities = @courier_type.available_cities.merge(City.indexable).ordered.limit(15)
    @faqs = Faq.published.for_scope(@courier_type.slug).ordered
    @faqs = Faq.published.for_scope("home").ordered.limit(8) if @faqs.blank?
    @referral_link = current_referral_link(courier_type: @courier_type)
    set_seo_meta(@courier_type)
  end
end
