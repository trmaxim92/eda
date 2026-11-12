class RegistrationsController < ApplicationController
  def go
    city = City.find_by(id: params[:city_id]) || City.find_by(slug: params[:city])
    courier_type = CourierType.find_by(id: params[:courier_type_id]) || CourierType.find_by(slug: params[:courier_type])
    link = ReferralResolver.new(city: city, courier_type: courier_type).call

    unless link&.trusted_url?
      redirect_to root_path, alert: "Сейчас доступна только заявка на подключение." and return
    end

    if duplicate_click?(link)
      redirect_to link.url, allow_other_host: true, status: :found and return
    end

    ReferralClick.create!(
      referral_link: link,
      city: city,
      courier_type: courier_type,
      clicked_at: Time.current,
      **attribution_attrs.slice(
        :landing_page, :referrer, :utm_source, :utm_medium, :utm_campaign, :utm_content, :utm_term, :session_identifier
      )
    )

    session[:last_referral_click_at] = Time.current.to_i
    session[:last_referral_link_id] = link.id

    redirect_to link.url, allow_other_host: true, status: :found
  end

  private

  def duplicate_click?(link)
    session[:last_referral_link_id].to_i == link.id &&
      session[:last_referral_click_at].to_i > 30.seconds.ago.to_i
  end
end
