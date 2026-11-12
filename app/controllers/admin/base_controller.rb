module Admin
  class BaseController < ApplicationController
    layout "admin"
    before_action :authenticate_user!
    before_action :ensure_active_user!

    private

    def ensure_active_user!
      return if current_user&.active?

      sign_out current_user
      redirect_to new_user_session_path, alert: "Аккаунт отключён"
    end
  end
end
