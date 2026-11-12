module UtmTrackable
  extend ActiveSupport::Concern

  UTM_KEYS = %w[utm_source utm_medium utm_campaign utm_content utm_term].freeze

  included do
    before_action :capture_utm_params
  end

  private

  def capture_utm_params
    UTM_KEYS.each do |key|
      session[key] = params[key] if params[key].present?
    end
    session[:landing_page] ||= request.path
    session[:initial_referrer] ||= request.referer
  end

  def attribution_attrs
    {
      landing_page: session[:landing_page] || request.path,
      referrer: session[:initial_referrer] || request.referer,
      utm_source: session["utm_source"],
      utm_medium: session["utm_medium"],
      utm_campaign: session["utm_campaign"],
      utm_content: session["utm_content"],
      utm_term: session["utm_term"],
      session_identifier: session.id.to_s
    }
  end
end
