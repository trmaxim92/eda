require "test_helper"

class CityTest < ActiveSupport::TestCase
  setup do
    @city = City.create!(
      name: "Тестоград",
      slug: "testograd",
      name_in_prepositional: "в Тестограде",
      connection_available: true,
      published: true,
      is_indexable: true,
      unique_text: "x" * 220,
      seo_title: "Работа курьером в Яндекс Еде в Тестограде",
      seo_description: "Описание",
      h1: "Работа курьером в Яндекс Еде в Тестограде"
    )
  end

  test "indexable when all gates pass" do
    assert @city.indexable?
  end

  test "not indexable without enough content" do
    @city.update_columns(unique_text: "short")
    assert_not @city.reload.indexable?
  end

  test "creates redirect on slug change" do
    @city.update!(slug: "testograd-new")
    redirect = Redirect.find_by(source_path: "/goroda/testograd")
    assert redirect
    assert_equal "/goroda/testograd-new/", redirect.target_path
    assert_equal 301, redirect.redirect_type
  end
end
