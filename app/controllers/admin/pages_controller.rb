module Admin
  class PagesController < BaseController
    before_action :set_page, only: %i[edit update destroy]

    def index
      authorize Page
      @pages = Page.ordered
    end

    def new
      @page = Page.new
      authorize @page
    end

    def create
      @page = Page.new(page_params)
      authorize @page
      if @page.save
        redirect_to admin_pages_path, notice: "Страница создана"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize @page
    end

    def update
      authorize @page
      if @page.update(page_params)
        redirect_to admin_pages_path, notice: "Страница обновлена"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @page
      @page.destroy!
      redirect_to admin_pages_path, notice: "Страница удалена"
    end

    private

    def set_page
      @page = Page.find(params[:id])
    end

    def page_params
      params.require(:page).permit(
        :title, :slug, :page_type, :summary, :body, :published, :position,
        :seo_title, :seo_description, :h1, :canonical_url, :robots_meta, :og_title, :og_description, :blocks
      )
    end
  end
end
