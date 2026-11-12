# Аудит сайта привлечения курьеров — сопоставление с ТЗ

Дата: 2026-11-12  
Стек: Rails 8.1, PostgreSQL, Hotwire, Docker prod `/opt/eda`  
Домен: park-dostavka.ru

**Правило:** не дублировать уже существующие модели/маршруты; дорабатывать поверх текущей архитектуры (`docs/regional_seo_architecture.md` уже внедрён).

---

## 1. Что уже реализовано

### 1.1. Единый справочник городов (`City`)

| Требование ТЗ | Текущее поле / механизм |
|---|---|
| name, slug, region | есть |
| активность | `published` + `connection_available` (нет отдельного `is_active`) |
| SEO title/description/H1 | `seo_title`, `seo_description`, `h1` |
| intro / local content | `short_description`, `unique_text` |
| условия / форматы / особенности | `delivery_methods`, `connection_conditions`, `work_features` |
| FAQ региональный | `faq_items` (jsonb) |
| indexable gate | `City#indexable?` (≥200 символов unique_text + SEO + published + available + `is_indexable`) |
| предложный падеж | `name_in_prepositional` (хранит фразу вида «в Уфе») |
| доступные типы | `CityCourierType` + `available_courier_types` |
| slug 301 | `after_update` → `Redirect` |

**Переиспользовать:** `City`, scopes `published` / `available` / `indexable`, `sync_courier_type_availability!`, admin form + readiness.

### 1.2. Региональные URL

| URL | Статус |
|---|---|
| `/goroda/` | есть (`CitiesController#index`, только `City.indexable`) |
| `/goroda/:slug/` | есть, 404 если не `indexable?` |
| `/goroda/:city/:type/` | есть (`CityCourierPage`, slug типа `peshiy-kurer`) |
| типы `/rabota-*-kurerom/` | есть, с блоком городов где формат доступен |

Публикация city×type только при: published + is_indexable + city.indexable? + тип available в городе + unique_text ≥ 200.

### 1.3. Выбор города без query-индексации

- `POST/DELETE select_city` → session + permanent cookie  
- Stimulus combobox с поиском по названию на главной  
- Нет `?city=` в публичных SEO-URL

### 1.4. Реферальная система

- `ReferralResolver`: город+тип → город → тип → default  
- `/go/register/` → клик `ReferralClick` → HTTP 302  
- `ReferralLink#trusted_url?` — whitelist доменов (anti open-redirect)  
- Кнопка скрывается через `registration_available?`  
- Клик ≠ регистрация (отдельная модель кликов; статусы lead отдельно)

### 1.5. Заявки

- Поля: имя, телефон, город, тип, согласие  
- UTM через `UtmTrackable` + landing/referrer/IP  
- Honeypot `company`  
- Prefill `selected_city_id` / `selected_courier_type_id` на city/type страницах  
- Thank-you `noindex`

### 1.6. SEO-инфраструктура

- `SeoMeta` concern: title, description, h1, canonical (без query), robots, OG  
- Split sitemap: pages / cities / city-types + index  
- `robots.txt`: Disallow `/admin/`, `/go/`, `/leads`, `/users/`  
- Admin: SEO-шаблоны, диагностика `/admin/seo`, фильтры городов, матрица типов  
- Тесты: city indexable, sitemap exclude noindex, seo template apply

### 1.7. Типы курьеров

Уникальные поля контента: description, features, requirements, documents, how_to_start, earnings_info, pros_cons, SEO, FAQ scope.

---

## 2. Что работает корректно

1. Единый источник городов для главной (каталог chips через `@cities = City.indexable`), каталога и типов (через `available_cities`).  
2. Тонкие city×type страницы не генерятся массово (только seed Уфа/пеший + admin).  
3. Sitemap не включает города с `is_indexable: false`.  
4. Реферальный приоритет соответствует ТЗ §6.  
5. Open Redirect закрыт whitelist’ом.  
6. Cookie-город не создаёт индексируемые URL.  
7. Prod: `/goroda/ufa/`, `/goroda/ufa/peshiy-kurer/`, split sitemap — 200.

---

## 3. Обнаруженные проблемы

### P0 — блокируют критерии готовности ТЗ

| ID | Проблема | Где |
|---|---|---|
| P0-1 | На главной **хардкод** featured-городов по slug | `home/index.html.erb` `%w[ufa moskva ...]` |
| P0-2 | Нет `is_featured` / `sort_order` в БД | `cities` |
| P0-3 | Нет родительного/дательного падежей; предложный — одна строка «в …» | `City` |
| P0-4 | **Демо-отзыв в seeds** публикуется (`published: true`) | `db/seeds.rb` |
| P0-5 | Нет Schema.org (Organization / WebSite / BreadcrumbList / FAQPage) | layout/views |
| P0-6 | Нет маски телефона на клиенте | `_lead_form` |
| P0-7 | Нет rate limiting заявок | `LeadsController` |
| P0-8 | Нет аналитических событий (Metrika/GA hooks есть в settings, событий нет) | frontend |

### P1 — качество SEO / UX

| ID | Проблема | Где |
|---|---|---|
| P1-1 | Каталог `/goroda/`: H1 «Города», нет поиска, нет группировки по регионам, слабый CTA | `cities/index` |
| P1-2 | Страница города: нет явных блоков «требования/документы», «преимущества», breadcrumbs | `cities/show` |
| P1-3 | City×type slug ≠ ТЗ `rabota-velokurerom` (сейчас `velokurer`) — **не ломать URL**, зафиксировать как принятый формат | routes/seeds |
| P1-4 | Canonical использует `request.original_url` без нормализации trailing slash | `SeoMeta` |
| P1-5 | Home lead-форма не подставляет `selected_city` автоматически | `home/index` → `_lead_form` |
| P1-6 | Hero: выбор формата не на первом экране (форматы ниже) | `home/index` |
| P1-7 | Бренд в UI «Яндекс Еда», defaults SEO всё ещё «Park Dostavka» | `SeoMeta`, SiteSetting seeds |
| P1-8 | Нет `content_updated_at` для региональной актуальности | `City` |
| P1-9 | Перелинковка типов на city-странице: общие URL, не всегда city×type | `cities/show` — частично есть |
| P1-10 | Админ-диагностика: нет предупреждений «нет склонений / нет рефералки» | `Admin::SeoController` |

### P2 — желательно

| ID | Проблема |
|---|---|
| P2-1 | Нет confirmed registrations (API/webhook) — только клики и leads |
| P2-2 | Lazy-loading / srcset для hero и type photos не везде |
| P2-3 | FAQPage schema нельзя вешать, если FAQ пустой — сейчас schema отсутствует вовсе |
| P2-4 | Цвета ТЗ упоминают «глубокий зелёный» — в CSS сейчас yellow/black/white (сохранить текущую концепцию сайта, не копировать референс) |
| P2-5 | Уведомление админа о заявке (email) — не найдено |
| P2-6 | Тесты склонений для разных типов городов — недостаточно |

### Грамматика

Явных шаблонов «в Уфа» / «Заявка в Уфа» в коде **не найдено**. Seeds используют «в Уфе», «в Казани» и т.д. Риск: fallback `в городе #{name}` и неполный предложный; нет genitive/dative для «Заявка из Москвы» и т.п.

---

## 4. Маппинг полей ТЗ → не создавать дубли

| Поле ТЗ | Действие |
|---|---|
| `is_active` | **Не добавлять.** Использовать `published` (+ `connection_available` для обслуживания). |
| `is_featured` | **Добавить** boolean |
| `sort_order` | **Добавить** integer |
| `seo_h1` | Уже есть как `h1` |
| `intro_text` | Уже есть как `short_description` |
| `local_content` | Уже есть как `unique_text` |
| `available_courier_types` | Уже через `CityCourierType` |
| `name_prepositional` | Есть `name_in_prepositional`; нормализовать/хелперы |
| `name_genitive`, `name_dative` | **Добавить** |
| отдельная модель городов | **Не создавать** |

---

## 5. Что переиспользовать

- Models: `City`, `CityCourierType`, `CityCourierPage`, `CourierType`, `SeoTemplate`, `ReferralLink`, `ReferralClick`, `Lead`, `Review`, `Faq`, `Redirect`, `Page`  
- Services: `ReferralResolver`, `SeoTemplateApplier`  
- Concerns: `SelectedCity`, `SeoMeta`, `UtmTrackable`  
- Controllers/views admin SEO + cities matrix  
- Split sitemaps, robots, go/register  

---

## 6. Миграции БД (потребуется)

```
cities:
  + is_featured boolean default false null: false
  + sort_order integer default 0 null: false
  + name_genitive string
  + name_dative string
  + content_updated_at datetime (optional, можно sync от updated_at при смене контента)
indexes: [is_featured], [sort_order]
```

Без удаления/переименования существующих колонок. Backfill склонений в seeds.

---

## 7. План реализации (после аудита)

**Этап 2 — данные:** featured/sort/declensions; убрать хардкод; единый `City.featured.ordered`; админ-поля; тесты склонений.  
**Этап 3 — SEO:** canonical trailing slash; Schema.org; каталог `/goroda/` (H1, поиск, CTA); усилить city show; admin diagnostics.  
**Этап 4 — рефералка:** уже ок; допилить статистику кликов vs leads в admin; не добавлять fake «confirmed».  
**Этап 5 — конверсия:** phone mask; home form prefill; rate limit; thank-you next step.  
**Этап 6 — дизайн:** hero city+types в первом viewport без перегруза; mobile tap targets; без смены стека.  
**Этап 7 — тесты + `docs/site_improvement_report.md`:** demo reviews off в prod seeds; полный чеклист ТЗ §15.

---

## 8. Явно НЕ делать

- Новые модели City/Page параллельно существующим  
- Массовая генерация city×type  
- Vue/React/SPA  
- Смена стека  
- Фиктивные Schema AggregateRating  
- Автоматическое склонение эвристиками без полей  
- Ломать текущие slug city×type (`peshiy-kurer` и т.д.) без 301-стратегии  
