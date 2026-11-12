module SeoMeta
  extend ActiveSupport::Concern

  included do
    helper_method :seo_meta
  end

  private

  def set_seo_meta(record = nil, **overrides)
    @seo_meta = {
      title: overrides[:title] || record&.try(:seo_title).presence || record&.try(:title) || SiteSetting.get("default_seo_title", "Park Dostavka"),
      description: overrides[:description] || record&.try(:seo_description).presence || SiteSetting.get("default_seo_description", ""),
      h1: overrides[:h1] || record&.try(:h1).presence || record&.try(:title),
      canonical: overrides[:canonical] || record&.try(:canonical_url).presence || request.original_url.split("?").first,
      robots: overrides[:robots] || record&.try(:robots_meta).presence || "index,follow",
      og_title: overrides[:og_title] || record&.try(:og_title).presence || overrides[:title] || record&.try(:seo_title),
      og_description: overrides[:og_description] || record&.try(:og_description).presence || overrides[:description] || record&.try(:seo_description),
      og_image: overrides[:og_image]
    }
  end

  def seo_meta
    @seo_meta || {
      title: SiteSetting.get("default_seo_title", "Park Dostavka"),
      description: SiteSetting.get("default_seo_description", ""),
      robots: "index,follow",
      canonical: request.original_url.split("?").first
    }
  end
end
