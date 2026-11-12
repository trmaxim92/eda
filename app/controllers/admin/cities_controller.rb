module Admin
  class CitiesController < BaseController
    before_action :set_city, only: %i[edit update destroy apply_seo_template]

    def index
      authorize City
      @cities = City.ordered
      @cities = @cities.published if params[:filter] == "published"
      @cities = @cities.where(published: false) if params[:filter] == "draft"
      @cities = @cities.available if params[:filter] == "available"
      @cities = @cities.where(connection_available: false) if params[:filter] == "closed"
      @cities = @cities.where(is_indexable: true) if params[:filter] == "indexable"
      @cities = @cities.where(is_indexable: false) if params[:filter] == "noindex"
      @cities = @cities.where(seo_title: [ nil, "" ]) if params[:filter] == "no_title"
      @cities = @cities.where(seo_description: [ nil, "" ]) if params[:filter] == "no_description"
      if params[:filter] == "no_content"
        @cities = @cities.select { |c| c.unique_text.to_s.strip.length < 200 }
      end
    end

    def new
      @city = City.new(is_indexable: true, country: "RU")
      authorize @city
      @courier_types = CourierType.ordered
    end

    def create
      @city = City.new(city_params)
      authorize @city
      if @city.save
        @city.sync_courier_type_availability!(type_availability_params)
        redirect_to edit_admin_city_path(@city), notice: "Город создан"
      else
        @courier_types = CourierType.ordered
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize @city
      @courier_types = CourierType.ordered
      @availability = @city.city_courier_types.index_by(&:courier_type_id)
    end

    def update
      authorize @city
      if @city.update(city_params)
        @city.sync_courier_type_availability!(type_availability_params)
        redirect_to edit_admin_city_path(@city), notice: "Город обновлён"
      else
        @courier_types = CourierType.ordered
        @availability = @city.city_courier_types.index_by(&:courier_type_id)
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @city
      @city.destroy!
      redirect_to admin_cities_path, notice: "Город удалён"
    end

    def apply_seo_template
      authorize @city, :update?
      SeoTemplateApplier.apply(@city, scope: "city", overwrite: params[:overwrite] == "1")
      if @city.save
        redirect_to edit_admin_city_path(@city), notice: "SEO из шаблона применено"
      else
        redirect_to edit_admin_city_path(@city), alert: @city.errors.full_messages.to_sentence
      end
    end

    private

    def set_city
      @city = City.find(params[:id])
    end

    def city_params
      params.require(:city).permit(
        :name, :slug, :region, :country, :name_in_prepositional, :short_description,
        :connection_available, :published, :is_indexable, :unique_text,
        :delivery_methods, :connection_conditions, :work_features,
        :seo_title, :seo_description, :h1, :canonical_url, :robots_meta, :og_title, :og_description
      )
    end

    def type_availability_params
      params.fetch(:courier_type_available, {}).permit!.to_h
    end
  end
end
