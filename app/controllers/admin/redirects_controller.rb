module Admin
  class RedirectsController < BaseController
    before_action :set_redirect, only: %i[edit update destroy]

    def index
      authorize Redirect
      @redirects = Redirect.order(:source_path)
    end

    def new
      @redirect = Redirect.new(redirect_type: 301, active: true)
      authorize @redirect
    end

    def create
      @redirect = Redirect.new(redirect_params)
      authorize @redirect
      if @redirect.save
        redirect_to admin_redirects_path, notice: "Редирект создан"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize @redirect
    end

    def update
      authorize @redirect
      if @redirect.update(redirect_params)
        redirect_to admin_redirects_path, notice: "Редирект обновлён"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @redirect
      @redirect.destroy!
      redirect_to admin_redirects_path, notice: "Редирект удалён"
    end

    private

    def set_redirect
      @redirect = Redirect.find(params[:id])
    end

    def redirect_params
      params.require(:redirect).permit(:source_path, :target_path, :redirect_type, :active)
    end
  end
end
