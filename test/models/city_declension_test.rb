require "test_helper"

class CityDeclensionTest < ActiveSupport::TestCase
  test "prepositional phrases stay grammatical for irregular cities" do
    samples = {
      "Москва" => { prep: "в Москве", genitive: "Москвы", dative: "Москве" },
      "Казань" => { prep: "в Казани", genitive: "Казани", dative: "Казани" },
      "Санкт-Петербург" => { prep: "в Санкт-Петербурге", genitive: "Санкт-Петербурга", dative: "Санкт-Петербургу" },
      "Нижний Новгород" => { prep: "в Нижнем Новгороде", genitive: "Нижнего Новгорода", dative: "Нижнему Новгороду" },
      "Саранск" => { prep: "в Саранске", genitive: "Саранска", dative: "Саранску" }
    }

    samples.each_with_index do |(name, forms), index|
      city = City.create!(
        name: name,
        slug: "declension-#{index}",
        name_in_prepositional: forms[:prep],
        name_genitive: forms[:genitive],
        name_dative: forms[:dative],
        connection_available: true,
        published: true,
        is_indexable: true,
        unique_text: "x" * 220,
        seo_title: "t",
        h1: "h #{forms[:prep]}"
      )

      assert_equal forms[:prep], city.name_prepositional
      assert_equal forms[:genitive], city.name_genitive_form
      assert_equal forms[:dative], city.name_dative_form
      assert_match(/#{Regexp.escape(forms[:prep])}/, "Работа курьером #{city.name_prepositional}")
      refute_match(/в #{Regexp.escape(name)}\b/, city.name_prepositional) unless name == "Казань"
    end
  end

  test "safe fallback without invented endings" do
    city = City.new(name: "Тестоград")
    assert_equal "в городе Тестоград", city.name_prepositional
    assert_equal "Тестоград", city.name_genitive_form
    assert_equal "Тестоград", city.name_dative_form
  end

  test "featured scope drives homepage list source" do
    City.create!(
      name: "Фичерград",
      slug: "featuregrad",
      name_in_prepositional: "в Фичерграде",
      name_genitive: "Фичерграда",
      name_dative: "Фичерграду",
      connection_available: true,
      published: true,
      is_indexable: true,
      is_featured: true,
      sort_order: 1,
      unique_text: "x" * 220,
      seo_title: "t",
      h1: "h"
    )

    assert City.indexable.featured.ordered.exists?(slug: "featuregrad")
  end
end
