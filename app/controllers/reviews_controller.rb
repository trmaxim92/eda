class ReviewsController < ApplicationController
  def index
    @reviews = Review.published.ordered
    @page = Page.find_by(page_type: "reviews", published: true)
    set_seo_meta(@page, title: @page&.seo_title || "Отзывы о работе курьером", h1: @page&.h1 || "Отзывы")
  end
end
