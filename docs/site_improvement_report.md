# Отчёт о доработках сайта (ТЗ improvement)

Дата: 2026-11-12  
Аудит: `docs/site_improvement_audit.md`

## Сделано

### Этап 1 — Аудит
- Составлен `docs/site_improvement_audit.md` с маппингом ТЗ → существующие сущности.
- Зафиксировано: не создавать параллельные модели City / city×type.

### Этап 2 — Данные и региональная архитектура
- Миграция `is_featured`, `sort_order`, `name_genitive`, `name_dative`, `content_updated_at`.
- `City.featured` / `City.ordered` (sort_order, name); убран хардкод slug на главной.
- Админка: склонения, featured, порядок, фильтры.
- Seeds: падежи для всех городов, featured-набор, демо-отзывы **unpublished**.

### Этап 3 — SEO
- Canonical с нормализацией trailing slash.
- Schema.org: Organization, WebSite, FAQPage (если FAQ есть).
- Каталог `/goroda/`: H1 по ТЗ, поиск, группировка по регионам, CTA.
- Страница города: breadcrumbs, блоки условий/требований, жёлтый self-register CTA.
- Admin SEO: предупреждения про склонения и отсутствие рефералки.

### Этап 4 — Рефералка
- Без переписывания: приоритет и open-redirect уже соответствовали ТЗ.
- Клик по-прежнему ≠ регистрация.

### Этап 5 — Конверсия
- Маска телефона (Stimulus).
- Prefill города в форме на главной.
- Rate limit заявок (session, 45 сек).
- Analytics bridge (Metrika/GA goals без PII).

### Этап 6 — UX
- Mobile tap targets (min-height кнопок).
- Поиск города в каталоге.

### Этап 7 — Тесты
- Добавлен `test/models/city_declension_test.rb` (Москва, Казань, СПб, НН, Саранск + fallback).
- Прогон: city + declension + seo template + cities/sitemaps controllers.

## Оставшиеся проблемы / вне скоупа этого прохода

1. Confirmed registrations через API/webhook — нет источника правды, не имитируем.
2. Email-уведомление админу о заявке.
3. Полный Metrika counter snippet (сейчас только ID + reachGoal bridge; счётчик нужно вставить при заполнении setting).
4. Article schema для блога — блог-заглушка.
5. Hero: выбор формата всё ещё ниже первого экрана (не перегружали hero карточками).
6. City×type slug остаются `peshiy-kurer` / `velokurer` (не ломали URL ради ТЗ-примера `rabota-velokurerom`).
7. Зелёный акцент из ТЗ не внедряли — сохранена текущая yellow/black/white концепция сайта.

## Критерий готовности (статус)

| Критерий | Статус |
|---|---|
| Основные страницы работают | OK (локально + предыдущий prod) |
| Региональные данные согласованы | OK (единый City + featured) |
| Ошибки склонения | OK (поля + тесты; fallback без эвристик) |
| Реферальная регистрация | OK (уже было) |
| SEO только с контентом | OK (`indexable?`) |
| Обе конверсионные цепочки | OK (заявка + /go/register) |
