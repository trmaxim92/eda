module Admin
  class SeoTemplatesController < BaseController
    before_action :set_template, only: %i[edit update destroy]

    def index
      authorize SeoTemplate
      @templates = SeoTemplate.order(:scope, :name)
    end

    def new
      @template = SeoTemplate.new(active: true)
      authorize @template
    end

    def create
      @template = SeoTemplate.new(template_params)
      authorize @template
      if @template.save
        redirect_to admin_seo_templates_path, notice: "Шаблон создан"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize @template
      @preview = @template.preview
    end

    def update
      authorize @template
      if @template.update(template_params)
        redirect_to edit_admin_seo_template_path(@template), notice: "Сохранено"
      else
        @preview = @template.preview
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @template
      @template.destroy!
      redirect_to admin_seo_templates_path, notice: "Удалено"
    end

    private

    def set_template
      @template = SeoTemplate.find(params[:id])
    end

    def template_params
      params.require(:seo_template).permit(
        :scope, :name, :title_template, :description_template, :h1_template, :active
      )
    end
  end
end
