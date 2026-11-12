namespace :seo do
  desc "Create/update CityCourierPage for every available city×type pair"
  task seed_city_courier_pages: :environment do
    type_copy = {
      "pedestrian" => {
        slug: "peshiy-kurer",
        work_as: "пешим курьером",
        how: "пешим курьером",
        focus: "короткие маршруты без транспорта: рестораны, магазины и аптеки в пешей доступности",
        gear: "нужен смартфон с Яндекс Про; термосумку обычно выдают после подключения"
      },
      "bike" => {
        slug: "velokurer",
        work_as: "велокурьером",
        how: "велокурьером",
        focus: "большую зону покрытия на велосипеде или электровеле и больше точек за смену",
        gear: "нужен исправный велосипед и смартфон с Яндекс Про"
      },
      "auto" => {
        slug: "avtokurer",
        work_as: "автокурьером",
        how: "автокурьером",
        focus: "дальние и мультизаказы, когда пеший и вело форматы не закрывают расстояние",
        gear: "нужны права, исправный автомобиль и смартфон с Яндекс Про"
      }
    }

    created = 0
    updated = 0
    skipped = 0

    City.indexable.find_each do |city|
      city.available_courier_types.merge(CourierType.published).find_each do |type|
        meta = type_copy[type.code]
        unless meta
          skipped += 1
          next
        end

        prep = city.name_prepositional
        page = CityCourierPage.find_or_initialize_by(city: city, courier_type: type)
        was_new = page.new_record?

        unique_text = [
          "Работа #{meta[:work_as]} в Яндекс Еде #{prep}: формат рассчитан на #{meta[:focus]}.",
          "На этой странице — условия именно для #{city.name} и формата «#{type.name}», без копирования общего текста города.",
          "Регион: #{city.region.presence || city.name}. Оставьте заявку или перейдите к самостоятельной регистрации, если реферальная ссылка активна.",
          "Для старта #{meta[:gear]}. График и загрузка #{prep} зависят от спроса и правил Яндекс Про.",
          "Сайт не является официальным ресурсом Яндекса: публикуем только города и форматы с доступным подключением."
        ].join(" ")

        page.assign_attributes(
          slug: meta[:slug],
          published: true,
          is_indexable: true,
          short_description: "#{type.name} Яндекс Еды #{prep}: заявка и подключение.",
          unique_text: unique_text,
          seo_title: "Работа #{meta[:work_as]} в Яндекс Еде #{prep}",
          seo_description: "Как устроиться #{meta[:how]} в Яндекс Еде #{prep}: требования, заявка и регистрация.",
          h1: "Работа #{meta[:work_as]} в Яндекс Еде #{prep}",
          faq_items: [
            {
              "question" => "Доступен ли формат «#{type.name}» #{prep}?",
              "answer" => "Да, на момент публикации формат отмечен как доступный. Актуальную загрузку уточняйте при подключении."
            },
            {
              "question" => "Чем эта страница отличается от общей страницы #{city.name}?",
              "answer" => "Здесь собраны условия и CTA именно для формата «#{type.name}» #{prep}."
            }
          ]
        )

        if page.save
          was_new ? created += 1 : updated += 1
          print "."
        else
          skipped += 1
          warn "\nFAIL #{city.slug}/#{type.code}: #{page.errors.full_messages.to_sentence}"
        end
      end
    end

    puts "\nCityCourierPage seed done: created=#{created} updated=#{updated} skipped=#{skipped} total=#{CityCourierPage.count}"
  end
end
