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

  def pages
    @entries = []
    STATIC_PATHS.each do |path|
      @entries << { loc: "#{request.base_url}#{path}", lastmod: Time.current }
    end
    CourierType.published.find_each do |type|
      @entries << { loc: "#{request.base_url}/#{type.slug}/", lastmod: type.updated_at }
    end
    Page.published.where.not(robots_meta: [ "noindex,follow", "noindex,nofollow" ]).find_each do |page|
      next if page.page_type == "home"
      @entries << { loc: "#{request.base_url}/#{page.slug}/", lastmod: page.updated_at }
    end
    render template: "sitemaps/urlset", formats: :xml
  end

  def cities
    @entries = City.indexable.map do |city|
      { loc: "#{request.base_url}/goroda/#{city.slug}/", lastmod: city.updated_at }
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
