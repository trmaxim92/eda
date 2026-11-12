module Admin
  class DashboardController < BaseController
    def index
      authorize :dashboard, :index?
      @leads_total = Lead.count
      @leads_new = Lead.new_lead.count
      @leads_today = Lead.today.count
      @clicks_total = ReferralClick.count
      @clicks_today = ReferralClick.today.count
      @clicks_week = ReferralClick.this_week.count
      @clicks_month = ReferralClick.this_month.count
      @popular_cities = Lead.where.not(city_id: nil).group(:city_id).order(Arel.sql("count_all desc")).limit(5).count
      @recent_leads = Lead.recent.limit(10)
    end
  end
end
