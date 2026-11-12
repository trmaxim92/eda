module Admin
  class CityCourierPagesController < BaseController
    before_action :set_page, only: %i[edit update destroy preview apply_seo_template]

    def index
      authorize CityCourierPage
      @pages = CityCourierPage.includes(:city, :courier_type).joins(:city, :courier_type).order("cities.name", "courier_types.position")
    end

    def new
      @page = CityCourierPage.new(is_indexable: false)
      authorize @page
      load_form_collections
    end

    def create
      @page = CityCourierPage.new(page_params)
      authorize @page
      if @page.save
        redirect_to edit_admin_city_courier_page_path(@page), notice: "Региональная страница создана"
      else
        load_form_collections
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize @page
      load_form_collections
    end

    def update
      authorize @page
      if @page.update(page_params)
        redirect_to edit_admin_city_courier_page_path(@page), notice: "Сохранено"
      else
        load_form_collections
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @page
      @page.destroy!
      redirect_to admin_city_courier_pages_path, notice: "Удалено"
    end

    def preview
      authorize @page, :show?
      @city = @page.city
      @courier_type = @page.courier_type
      @faqs = Array(@page.faq_items)
      @referral_link = current_referral_link(city: @city, courier_type: @courier_type)
      render "city_courier_pages/show", layout: "application"
    end

    def apply_seo_template
      authorize @page, :update?
      SeoTemplateApplier.apply(@page, scope: "city_courier", overwrite: params[:overwrite] == "1")
      if @page.save
        redirect_to edit_admin_city_courier_page_path(@page), notice: "SEO из шаблона применено"
      else
        redirect_to edit_admin_city_courier_page_path(@page), alert: @page.errors.full_messages.to_sentence
      end
    end

    private

    def set_page
      @page = CityCourierPage.find(params[:id])
    end

    def load_form_collections
      @cities = City.ordered
      @courier_types = CourierType.ordered
    end

    def page_params
      params.require(:city_courier_page).permit(
        :city_id, :courier_type_id, :slug, :published, :is_indexable,
        :unique_text, :short_description, :seo_title, :seo_description, :h1,
        :canonical_url, :robots_meta, :og_title, :og_description
      )
    end
  end
end
