module Admin
  class SiteSettingsController < BaseController
    before_action :set_site_setting, only: %i[edit update]

    def index
      authorize SiteSetting
      @site_settings = SiteSetting.order(:key)
    end

    def edit
      authorize @site_setting
    end

    def update
      authorize @site_setting
      if @site_setting.update(site_setting_params)
        redirect_to admin_site_settings_path, notice: "Настройка обновлена"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_site_setting
      @site_setting = SiteSetting.find(params[:id])
    end

    def site_setting_params
      params.require(:site_setting).permit(:value, :value_type)
    end
  end
end
