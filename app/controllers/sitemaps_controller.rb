class SitemapsController < ApplicationController
  STATIC_PATHS = %w[
    /
    /rabota-v-yandex-eda/
    /rabota-kurerom/
    /usloviya-raboty/
    /rabota-cherez-park/
    /otzyvy/
    /goroda/
    /kontakty/
  ].freeze

  def index
    @sitemaps = [
      { loc: sitemap_pages_url(format: :xml), lastmod: Page.published.maximum(:updated_at) },
      { loc: sitemap_cities_url(format: :xml), lastmod: City.indexable.maximum(:updated_at) },
      { loc: sitemap_city_types_url(format: :xml), lastmod: CityCourierPage.indexable.maximum(:updated_at) }
    ]
    render formats: :xml
  end

  # Virtual page_types that already have a dedicated public URL in STATIC_PATHS / routes.
  SKIP_PAGE_TYPES = %w[home cities_index reviews blog_index blog].freeze

  def pages
    @entries = []
    seen = {}

    add_entry = lambda do |path, lastmod|
      loc = "#{request.base_url}#{path}"
      return if seen[loc]

      seen[loc] = true
      @entries << { loc: loc, lastmod: lastmod }
    end

    STATIC_PATHS.each { |path| add_entry.call(path, Time.current) }
    CourierType.published.find_each { |type| add_entry.call("/#{type.slug}/", type.updated_at) }
    Page.published.where.not(robots_meta: [ "noindex,follow", "noindex,nofollow" ]).find_each do |page|
      next if SKIP_PAGE_TYPES.include?(page.page_type)

      add_entry.call("/#{page.slug}/", page.updated_at)
    end
    render template: "sitemaps/urlset", formats: :xml
  end

  def cities
    @entries = City.indexable.select(&:indexable?).map do |city|
      { loc: "#{request.base_url}/goroda/#{city.slug}/", lastmod: city.content_updated_at || city.updated_at }
    end
    render template: "sitemaps/urlset", formats: :xml
  end

  def city_types
    @entries = CityCourierPage.includes(:city, :courier_type).to_a.select(&:indexable?).map do |page|
      { loc: "#{request.base_url}#{page.public_path}", lastmod: page.updated_at }
    end
    render template: "sitemaps/urlset", formats: :xml
  end
end
