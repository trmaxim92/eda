class BlogController < ApplicationController
  def index
    @page = Page.find_by(page_type: "blog_index", published: true)
    set_seo_meta(
      @page,
      title: @page&.seo_title || "Блог — Park Dostavka",
      description: "Информационный раздел о работе курьером. Статьи появятся в следующей версии.",
      robots: "noindex,follow"
    )
  end
end
