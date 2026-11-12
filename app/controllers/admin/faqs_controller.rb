module Admin
  class FaqsController < BaseController
    before_action :set_faq, only: %i[edit update destroy]

    def index
      authorize Faq
      @faqs = Faq.ordered
    end

    def new
      @faq = Faq.new
      authorize @faq
    end

    def create
      @faq = Faq.new(faq_params)
      authorize @faq
      if @faq.save
        redirect_to admin_faqs_path, notice: "FAQ создан"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize @faq
    end

    def update
      authorize @faq
      if @faq.update(faq_params)
        redirect_to admin_faqs_path, notice: "FAQ обновлён"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @faq
      @faq.destroy!
      redirect_to admin_faqs_path, notice: "FAQ удалён"
    end

    private

    def set_faq
      @faq = Faq.find(params[:id])
    end

    def faq_params
      params.require(:faq).permit(:question, :answer, :group_name, :page_scope, :published, :position)
    end
  end
end
