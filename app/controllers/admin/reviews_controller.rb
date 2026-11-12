module Admin
  class ReviewsController < BaseController
    before_action :set_review, only: %i[edit update destroy]

    def index
      authorize Review
      @reviews = Review.order(created_at: :desc)
    end

    def new
      @review = Review.new
      authorize @review
    end

    def create
      @review = Review.new(review_params)
      authorize @review
      if @review.save
        redirect_to admin_reviews_path, notice: "Отзыв создан"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize @review
    end

    def update
      authorize @review
      if @review.update(review_params)
        redirect_to admin_reviews_path, notice: "Отзыв обновлён"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @review
      @review.destroy!
      redirect_to admin_reviews_path, notice: "Отзыв удалён"
    end

    private

    def set_review
      @review = Review.find(params[:id])
    end

    def review_params
      params.require(:review).permit(
        :author_name, :city_id, :courier_type_id, :city_name, :courier_type_name,
        :body, :reviewed_on, :published, :moderated, :position
      )
    end
  end
end
