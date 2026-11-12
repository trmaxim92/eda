module Admin
  class CourierTypesController < BaseController
    before_action :set_courier_type, only: %i[edit update destroy]

    def index
      authorize CourierType
      @courier_types = CourierType.ordered
    end

    def new
      @courier_type = CourierType.new
      authorize @courier_type
    end

    def create
      @courier_type = CourierType.new(courier_type_params)
      authorize @courier_type
      if @courier_type.save
        redirect_to admin_courier_types_path, notice: "Тип курьера создан"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize @courier_type
    end

    def update
      authorize @courier_type
      if @courier_type.update(courier_type_params)
        redirect_to admin_courier_types_path, notice: "Тип курьера обновлён"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @courier_type
      @courier_type.destroy!
      redirect_to admin_courier_types_path, notice: "Тип курьера удалён"
    end

    private

    def set_courier_type
      @courier_type = CourierType.find(params[:id])
    end

    def courier_type_params
      params.require(:courier_type).permit(
        :name, :slug, :code, :description, :features, :requirements, :documents,
        :how_to_start, :earnings_info, :pros_cons, :published, :position,
        :seo_title, :seo_description, :h1, :canonical_url, :robots_meta, :og_title, :og_description
      )
    end
  end
end
