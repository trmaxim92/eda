class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include SeoMeta
  include UtmTrackable

  allow_browser versions: :modern
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  helper_method :current_referral_link, :site_name

  private

  def site_name
    SiteSetting.get("site_name", "Park Dostavka")
  end

  def current_referral_link(city: nil, courier_type: nil)
    ReferralResolver.new(city: city, courier_type: courier_type).call
  end

  def user_not_authorized
    redirect_to admin_root_path, alert: "Недостаточно прав"
  rescue ActionController::UrlGenerationError
    redirect_to root_path, alert: "Недостаточно прав"
  end
end
