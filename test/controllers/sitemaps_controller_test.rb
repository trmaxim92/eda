require "test_helper"

class SitemapsControllerTest < ActionDispatch::IntegrationTest
  test "sitemap index lists child sitemaps" do
    get sitemap_path(format: :xml)
    assert_response :success
    assert_match "sitemap-cities.xml", response.body
    assert_match "sitemap-pages.xml", response.body
  end

  test "cities sitemap excludes noindex cities" do
    city = City.create!(
      name: "Скрытый",
      slug: "skrytyy",
      name_in_prepositional: "в Скрытом",
      connection_available: true,
      published: true,
      is_indexable: false,
      unique_text: "x" * 220,
      seo_title: "t",
      seo_description: "d",
      h1: "h"
    )
    get sitemap_cities_path(format: :xml)
    assert_response :success
    assert_no_match city.slug, response.body
  end
end
