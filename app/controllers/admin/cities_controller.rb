module Admin
  class CitiesController < BaseController
    before_action :set_city, only: %i[edit update destroy]

    def index
      authorize City
      @cities = City.ordered
    end

    def new
      @city = City.new
      authorize @city
    end

    def create
      @city = City.new(city_params)
      authorize @city
      if @city.save
        redirect_to admin_cities_path, notice: "Город создан"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize @city
    end

    def update
      authorize @city
      if @city.update(city_params)
        redirect_to admin_cities_path, notice: "Город обновлён"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @city
      @city.destroy!
      redirect_to admin_cities_path, notice: "Город удалён"
    end

    private

    def set_city
      @city = City.find(params[:id])
    end

    def city_params
      params.require(:city).permit(
        :name, :slug, :region, :connection_available, :published, :unique_text,
        :delivery_methods, :connection_conditions, :work_features,
        :seo_title, :seo_description, :h1, :canonical_url, :robots_meta, :og_title, :og_description
      )
    end
  end
end
