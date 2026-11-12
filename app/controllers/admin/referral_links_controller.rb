module Admin
  class ReferralLinksController < BaseController
    before_action :set_referral_link, only: %i[show edit update destroy]

    def index
      authorize ReferralLink
      @referral_links = ReferralLink.ordered.includes(:city, :courier_type)
    end

    def show
      authorize @referral_link
      @clicks = @referral_link.referral_clicks.order(clicked_at: :desc).limit(100)
      @clicks_today = @referral_link.referral_clicks.today.count
      @clicks_week = @referral_link.referral_clicks.this_week.count
      @clicks_month = @referral_link.referral_clicks.this_month.count
    end

    def new
      @referral_link = ReferralLink.new
      authorize @referral_link
    end

    def create
      @referral_link = ReferralLink.new(referral_link_params)
      authorize @referral_link
      if @referral_link.save
        redirect_to admin_referral_links_path, notice: "Ссылка создана"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize @referral_link
    end

    def update
      authorize @referral_link
      if @referral_link.update(referral_link_params)
        redirect_to admin_referral_links_path, notice: "Ссылка обновлена"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @referral_link
      @referral_link.destroy!
      redirect_to admin_referral_links_path, notice: "Ссылка удалена"
    end

    private

    def set_referral_link
      @referral_link = ReferralLink.find(params[:id])
    end

    def referral_link_params
      params.require(:referral_link).permit(
        :name, :url, :city_id, :courier_type_id, :is_active, :is_default, :priority, :description
      )
    end
  end
end
