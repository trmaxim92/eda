class CourierTypesController < ApplicationController
  def show
    @courier_type = CourierType.published.find_by!(slug: params[:slug])
    @cities = City.published.available.ordered
    @faqs = Faq.published.for_scope(@courier_type.slug).ordered
    @faqs = Faq.published.for_scope("home").ordered.limit(8) if @faqs.blank?
    @referral_link = current_referral_link(courier_type: @courier_type)
    set_seo_meta(@courier_type)
  end
end
