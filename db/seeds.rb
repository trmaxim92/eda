puts "Seeding Park Dostavka..."

User.find_or_create_by!(email: "admin@park-dostavka.ru") do |user|
  user.name = "Super Admin"
  user.password = ENV.fetch("ADMIN_PASSWORD", "ChangeMeNow!")
  user.password_confirmation = ENV.fetch("ADMIN_PASSWORD", "ChangeMeNow!")
  user.role = :super_admin
  user.active = true
end

{
  "site_name" => "Park Dostavka",
  "contact_phone" => "+7 (900) 000-00-00",
  "contact_email" => "hello@park-dostavka.ru",
  "default_seo_title" => "Работа курьером в Яндекс Еде — Park Dostavka",
  "default_seo_description" => "Подключение курьеров к Яндекс Еде через парк-партнёр park-dostavka.ru",
  "calc_hourly_rate" => "350",
  "yandex_metrika_id" => "",
  "ga4_id" => ""
}.each do |key, value|
  SiteSetting.set(key, value, value_type: key == "calc_hourly_rate" ? "integer" : "string")
end

pedestrian = CourierType.find_or_initialize_by(code: "pedestrian")
pedestrian.assign_attributes(
  name: "Пеший курьер",
  slug: "rabota-peshim-kurerom",
  description: "Работа пешим курьером в Яндекс Еде: доставка заказов пешком без автомобиля.",
  features: "Доставка на близкие расстояния. Подходит тем, кто хочет начать без транспорта.",
  requirements: "Возраст по требованиям платформы. Смартфон. Готовность к пешим маршрутам.",
  documents: "Паспорт и данные для оформления самозанятости или иной актуальный статус.",
  how_to_start: "Выберите город, оставьте заявку или перейдите к самостоятельной регистрации, подготовьте документы и пройдите подключение.",
  earnings_info: "Доход зависит от числа заказов, района и часов работы. Используйте калькулятор только как ориентир.",
  pros_cons: "Плюсы: низкий порог входа. Ограничения: меньше радиус и зависимость от погоды.",
  seo_title: "Работа пешим курьером в Яндекс Еде",
  seo_description: "Как устроиться пешим курьером через парк Park Dostavka: требования, документы и подключение.",
  h1: "Работа пешим курьером в Яндекс Еде",
  published: true,
  position: 1
)
pedestrian.save!

bike = CourierType.find_or_initialize_by(code: "bike")
bike.assign_attributes(
  name: "Велокурьер",
  slug: "rabota-velokurerom",
  description: "Доставка заказов на велосипеде: больше мобильности, чем у пешего формата.",
  features: "Подходит для города с удобной велоинфраструктурой.",
  requirements: "Велосипед в исправном состоянии, смартфон, соответствие возрастным требованиям.",
  documents: "Паспорт и данные для оформления.",
  how_to_start: "Выберите велоформат, город и способ регистрации.",
  earnings_info: "Ориентир зависит от смены и плотности заказов. Не является гарантией.",
  pros_cons: "Плюсы: скорость. Ограничения: сезонность и необходимость ухода за велосипедом.",
  seo_title: "Работа велокурьером в Яндекс Еде",
  seo_description: "Условия работы велокурьером и подключение через парк-партнёр.",
  h1: "Работа велокурьером в Яндекс Еде",
  published: true,
  position: 2
)
bike.save!

auto = CourierType.find_or_initialize_by(code: "auto")
auto.assign_attributes(
  name: "Автокурьер",
  slug: "rabota-avtokurerom",
  description: "Доставка на личном автомобиле: дальние и крупные заказы.",
  features: "Важны исправный автомобиль и готовность к городским поездкам.",
  requirements: "Водительские права, автомобиль, соответствие требованиям платформы.",
  documents: "Паспорт, водительское удостоверение и данные автомобиля при необходимости.",
  how_to_start: "Оставьте заявку или зарегистрируйтесь самостоятельно, затем пройдите проверку данных.",
  earnings_info: "Фактический доход зависит от маршрутов, топлива и загрузки.",
  pros_cons: "Плюсы: больше заказов на расстояние. Ограничения: расходы на авто.",
  seo_title: "Работа автокурьером в Яндекс Еде",
  seo_description: "Как подключиться автокурьером через парк Park Dostavka.",
  h1: "Работа автокурьером в Яндекс Еде",
  published: true,
  position: 3
)
auto.save!

city_payloads = [
  {
    name: "Москва", slug: "moskva", region: "Москва",
    unique_text: "В Москве парк Park Dostavka помогает кандидатам разобраться с подключением к доставке Яндекс Еды: выбрать формат курьера, подготовить документы и пройти этапы регистрации. На странице собраны условия для пеших, вело- и автокурьеров, актуальная информация о доступности подключения и способы связи с представителем парка. Мы не являемся официальным сайтом Яндекса — это сайт парка-партнёра для привлечения и сопровождения курьеров."
  },
  {
    name: "Казань", slug: "kazan", region: "Республика Татарстан",
    unique_text: "Работа курьером в Яндекс Еде в Казани через парк Park Dostavka: помогаем выбрать способ доставки, подготовить документы и пройти подключение. Страница содержит локальные особенности, FAQ и форму заявки. Публикуем только города, где подключение реально доступно, без шаблонных массовых страниц."
  },
  {
    name: "Киров", slug: "kirov", region: "Кировская область",
    unique_text: "В Кирове можно рассмотреть подключение к доставке через парк-партнёр Park Dostavka. На странице описаны доступные форматы курьерской работы, порядок заявки и самостоятельной регистрации, а также базовые требования. Перед публикацией мы проверяем доступность подключения и наполняем страницу уникальным текстом."
  },
  {
    name: "Саранск", slug: "saransk", region: "Республика Мордовия",
    unique_text: "Саранск: информация о работе курьером в Яндекс Еде через парк Park Dostavka. Здесь можно оставить заявку, узнать про документы и выбрать удобный сценарий старта. Сайт принадлежит парку-партнёру и не заменяет официальные материалы платформы."
  }
]

city_payloads.each do |payload|
  city = City.find_or_initialize_by(slug: payload[:slug])
  city.assign_attributes(
    payload.merge(
      connection_available: true,
      published: true,
      delivery_methods: "Пеший, вело и авто — при наличии активного формата в городе.",
      connection_conditions: "Оставьте заявку или перейдите по реферальной ссылке парка.",
      work_features: "График и загрузка зависят от спроса и условий платформы.",
      seo_title: "Работа курьером в Яндекс Еде — #{payload[:name]}",
      seo_description: "Подключение курьеров в #{payload[:name]} через парк Park Dostavka.",
      h1: "Работа курьером в Яндекс Еде в городе #{payload[:name]}",
      faq_items: [
        { "question" => "Как устроиться в #{payload[:name]}?", "answer" => "Оставьте заявку на этой странице или зарегистрируйтесь самостоятельно, если ссылка активна." },
        { "question" => "Какие форматы доступны?", "answer" => "Пеший, вело и авто — уточняйте актуальность при подключении." }
      ]
    )
  )
  city.save!
end

pages = [
  [ "home", "home", "Работа курьером в Яндекс Еде", "Главная страница парка Park Dostavka" ],
  [ "rabota-v-yandex-eda", "content", "Работа в Яндекс Еде", "Условия и подключение через парк-партнёр" ],
  [ "rabota-kurerom", "content", "Работа курьером", "Обзор форматов курьерской доставки" ],
  [ "usloviya-raboty", "content", "Условия работы", "Требования, документы, выплаты и порядок подключения" ],
  [ "rabota-cherez-park", "content", "Работа через парк", "Чем парк отличается от самостоятельной регистрации" ],
  [ "kontakty", "contacts", "Контакты", "Связь с представителем парка Park Dostavka" ],
  [ "cities_index", "cities_index", "Города", "Список городов с доступным подключением" ],
  [ "reviews", "reviews", "Отзывы", "Отзывы курьеров о работе" ],
  [ "blog", "blog_index", "Блог", "Информационный раздел" ]
]

pages.each_with_index do |(slug, page_type, title, summary), index|
  page = Page.find_or_initialize_by(slug: slug)
  body = case slug
  when "rabota-cherez-park"
    "<p>Парк-партнёр помогает кандидатам с подключением к платформе доставки. Park Dostavka не является официальным сайтом Яндекса и не подменяет собой платформу.</p><p>Через парк можно получить консультацию, помощь с заявкой и сопровождение на этапе регистрации. Самостоятельная регистрация доступна по реферальной ссылке, если она активна.</p>"
  when "usloviya-raboty"
    "<p>Кто может работать курьером, какие документы нужны, как проходит подключение и получение выплат — зависит от актуальных правил платформы и региона.</p><p>Мы публикуем только проверяемую информацию и не даём юридических или финансовых обещаний без подтверждения.</p>"
  when "kontakty"
    "<p>Свяжитесь с представителем парка по телефону или email из подвала сайта либо оставьте заявку — перезвоним.</p>"
  else
    "<p>#{summary}. Актуальные детали уточняйте при подключении. Сайт принадлежит парку-партнёру park-dostavka.ru.</p>"
  end

  page.assign_attributes(
    title: title,
    page_type: page_type,
    summary: summary,
    body: body,
    published: true,
    position: index,
    seo_title: "#{title} — Park Dostavka",
    seo_description: summary,
    h1: title,
    robots_meta: page_type == "blog_index" ? "noindex,follow" : "index,follow"
  )
  page.save!
end

[
  [ "Как устроиться курьером в Яндекс Еду?", "Выберите формат и город, затем оставьте заявку или перейдите к самостоятельной регистрации." ],
  [ "Что нужно для начала работы?", "Документы, смартфон и соответствие требованиям выбранного формата доставки." ],
  [ "Можно ли работать пешим курьером?", "Да, если в вашем городе доступен пеший формат." ],
  [ "Как происходит подключение через парк?", "Парк помогает с заявкой и сопровождением. Это не официальный сайт Яндекса." ],
  [ "Как зарегистрироваться самостоятельно?", "Если активна реферальная ссылка, нажмите кнопку регистрации — мы зафиксируем переход и перенаправим вас." ],
  [ "Как происходит получение выплат?", "Порядок выплат определяется условиями платформы и вашим статусом оформления." ]
].each_with_index do |(question, answer), index|
  Faq.find_or_create_by!(question: question) do |faq|
    faq.answer = answer
    faq.page_scope = "home"
    faq.published = true
    faq.position = index
  end
end

Review.find_or_create_by!(author_name: "Алексей", body: "Помогли разобраться с заявкой и документами. Это демо-отзыв для MVP, помеченный как модерируемый пример.") do |review|
  review.city_name = "Москва"
  review.courier_type_name = "Пеший"
  review.reviewed_on = Date.current
  review.moderated = true
  review.published = true
end

# Placeholder trusted default referral link (replace with real park URL later).
ReferralLink.find_or_initialize_by(name: "Default Yandex Eda").tap do |link|
  link.url = "https://eda.yandex.ru/"
  link.is_active = true
  link.is_default = true
  link.priority = 1
  link.description = "Заглушка до реальной реферальной ссылки парка"
  link.save!
end

puts "Seed complete. Admin: admin@park-dostavka.ru (password from ADMIN_PASSWORD or ChangeMeNow!)"
