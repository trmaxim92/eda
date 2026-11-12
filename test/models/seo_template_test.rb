require "test_helper"

class SeoTemplateTest < ActiveSupport::TestCase
  test "renders variables and keeps manual fields" do
    city = City.new(name: "Уфа", name_in_prepositional: "в Уфе")
    template = SeoTemplate.new(
      scope: "city",
      name: "t",
      title_template: "Работа {city_prep}",
      description_template: "Desc {city}",
      h1_template: "H1 {city_prep}"
    )
    city.seo_title = "Ручной title"
    template.apply_to(city, city: city, overwrite: false)
    assert_equal "Ручной title", city.seo_title
    assert_equal "Desc Уфа", city.seo_description
    assert_equal "H1 в Уфе", city.h1
  end
end
