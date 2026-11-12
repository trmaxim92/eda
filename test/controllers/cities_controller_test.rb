require "test_helper"

class CitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @city = City.create!(
      name: "УфаТест",
      slug: "ufa-test",
      name_in_prepositional: "в УфеТесте",
      connection_available: true,
      published: true,
      is_indexable: true,
      unique_text: "Уникальный текст для тестового города " + ("слово " * 40),
      seo_title: "Работа курьером в Яндекс Еде в УфеТесте",
      seo_description: "Описание теста",
      h1: "Работа курьером в Яндекс Еде в УфеТесте"
    )
    type = CourierType.find_or_create_by!(code: "pedestrian") do |t|
      t.name = "Пеший курьер"
      t.slug = "rabota-peshim-kurerom"
      t.published = true
    end
    CityCourierType.create!(city: @city, courier_type: type, available: true)
  end

  test "shows published indexable city" do
    get gorod_path(@city)
    assert_response :success
    assert_select "h1", /УфеТесте/
    assert_select "title", /УфеТесте/
  end

  test "404 for unknown city" do
    get "/goroda/no-such-city"
    assert_response :not_found
  end

  test "404 for non-indexable city" do
    @city.update!(is_indexable: false)
    get gorod_path(@city)
    assert_response :not_found
  end
end
