# Региональная SEO-архитектура — Парк Доставка

Документ этапа 2 по ТЗ регионального SEO.  
**Статус:** на согласование. Масштабная реализация не начинается до утверждения.

---

## 1. Текущее состояние (аудит)

### Уже есть

| Компонент | Состояние |
|-----------|-----------|
| Городские URL `/goroda/:slug/` | Работают |
| Поля SEO у City (`seo_title`, `seo_description`, `h1`, `canonical_url`, `robots_meta`) | Есть |
| `City#indexable?` (published + connection + unique_text ≥ 200) | Есть |
| Sitemap включает только indexable-города | Есть |
| ReferralLink: город / тип / город+тип / default | Есть (`ReferralResolver`) |
| Админка городов (базовый CRUD) | Есть |
| Глобальные страницы типов `/rabota-*-kurerom/` | Есть |
| Ручные 301 через Redirect | Есть |

### Критичные пробелы

1. **Нет связи City ↔ CourierType** — все типы считаются доступными везде.
2. **Нет региональных страниц типа** `/goroda/:city/:type/`.
3. **Нет SEO-шаблонов** и поля склонения (`name_in_prepositional`).
4. **Нет выбора города на главной** (cookie/session) без индексируемых GET.
5. **Админка городов неполная** (нет FAQ/blocks/robots/og, нет матрицы типов, нет диагностики).
6. **Один sitemap**, `@pages` загружается, но не выводится; нет `lastmod`.
7. **Нет авто-301 при смене slug** города.
8. **Индекс `/goroda/`** ссылается на `available`, не на `indexable?` → риск ссылок на 404.

---

## 2. Целевая структура URL (3 уровня)

```
Уровень 1 — общие SEO-страницы (без города)
  / , /rabota-v-yandex-eda/ , /rabota-kurerom/
  /rabota-peshim-kurerom/ , /rabota-velokurerom/ , /rabota-avtokurerom/
  /usloviya-raboty/ , /rabota-cherez-park/ , /otzyvy/

Уровень 2 — город
  /goroda/
  /goroda/:city_slug/

Уровень 3 — город × тип (только вручную опубликованные)
  /goroda/:city_slug/:courier_type_slug/
  примеры: /goroda/ufa/peshiy-kurer/ , /goroda/kazan/avtokurer/
```

**Запрещено индексировать:** `/?city=ufa`, `/rabota-kurerom/?city=ufa`.  
Выбор города на главной — только cookie/session; канонический URL страницы не меняется.

---

## 3. Модели и связи

### 3.1. City (расширение существующей)

Сохранить текущую таблицу, добавить:

| Поле | Назначение |
|------|------------|
| `name_in_prepositional` | «в Уфе», «в Москве» — для Title/H1 |
| `country` | default `RU` |
| `short_description` | краткий лид |
| `is_indexable` | явный флаг (дополнительно к эвристике) |
| `content` / оставить `unique_text` + `blocks` | уникальный контент |
| существующие: `delivery_methods`, `connection_conditions`, `work_features`, `faq_items`, SEO/OG | без ломки |

**Правило индексации (итоговый `indexable?`):**

```
published && connection_available && is_indexable
&& unique_text.length >= 200
&& seo_title.present? && seo_h1/h1.present?
```

Неопубликованный / неиндексируемый город: **404** на публичном show (как сейчас для non-indexable), **не** редирект на главную.

### 3.2. CityCourierType (новая join)

```
city_id, courier_type_id
available: boolean (default false)
notes: text (опционально)
unique [city_id, courier_type_id]
```

Админ явно включает пеший/вело/авто по городу.  
На `/goroda/:slug/` и в блоках «где доступен пеший» — только `available: true`.

### 3.3. CityCourierPage (региональная страница типа)

Отдельная сущность, **не** массовая генерация:

```
city_id, courier_type_id
slug (segment, напр. peshiy-kurer) — или берём из CourierType.slug
published, is_indexable
unique_text / blocks / faq_items
seo_title, seo_description, h1, canonical_url, robots_meta, og_*
```

Публичный URL только если `published && is_indexable && city.indexable? && join.available`.  
Иначе 404. Preview в админке без индексации.

### 3.4. SeoTemplate (новая)

```
scope: city | courier_type | city_courier
title_template, description_template, h1_template
```

Переменные: `{city}`, `{city_prep}` (`name_in_prepositional`), `{courier_type}`.  
Применение: кнопка «Заполнить из шаблона» — **не перезаписывает** непустые ручные поля.  
Предупреждения: длина title > 70, description > 160; проверка дублей title/description среди опубликованных.

### 3.5. Redirect при смене slug

При `City#update` / `CityCourierPage#update`, если `slug` изменился → создать `Redirect` 301 со старого URL на новый (использовать существующую модель `Redirect` + middleware).

---

## 4. Правила метаданных

1. Приоритет: **ручные поля** > результат шаблона > fallback.
2. Город: Title/H1 с `{city_prep}` («в Уфе»), не сырой `name`.
3. Title, H1 и первый абзац согласованы по смыслу.
4. Canonical = стабильный публичный URL (или явный `canonical_url`).
5. Без cloaking / подмены Title по User-Agent робота.

Пример (шаблон, не жёсткий контент):

- Title: `Работа курьером в Яндекс Еде {city_prep} — подключение и условия`
- H1: `Работа курьером в Яндекс Еде {city_prep}`

---

## 5. Контроллеры и маршруты

| Маршрут | Контроллер | Примечание |
|---------|------------|------------|
| `GET /goroda` | `CitiesController#index` | только indexable |
| `GET /goroda/:slug` | `CitiesController#show` | 404 если не indexable |
| `GET /goroda/:city_slug/:courier_type_slug` | `CityCourierPagesController#show` | только явные страницы |
| Admin cities + join types + SEO templates + diagnostics | `Admin::CitiesController`, `Admin::SeoTemplatesController`, `Admin::SeoController` | |

Согласование с Rails: существующие `/rabota-peshim-kurerom` и т.д. **не ломаем**; региональный сегмент — отдельный ресурс под `/goroda/...`.

---

## 6. Главная: выбор города

- UI: поиск + список доступных городов + cookie/`session[:city_slug]`.
- После выбора: блок доступных типов (из join), CTA через `ReferralResolver(city:, type:)`, ссылка «Страница города».
- **Canonical главной** остаётся `/`. Параметр city в URL не используется для SEO.
- Индексируемый контент главной самодостаточен без cookie (SSR общих блоков + список городов ссылками).

---

## 7. Перелинковка (без спама)

| Страница | Блок |
|----------|------|
| Главная | 3 типа + 6–8 популярных городов + условия |
| Город | только **доступные** типы → либо `/goroda/x/y/`, либо глобальный тип + якорь; условия; парк |
| Тип курьера | города, где `available` для этого типа (лимит ~15 + «все») |
| Блог (позже) | релевантные города/типы |

Не выводить сотни городов на каждой странице.

---

## 8. Sitemap и индексация

Раздельные файлы + индекс:

```
/sitemap.xml              → sitemapindex
/sitemap-pages.xml
/sitemap-cities.xml
/sitemap-city-types.xml
/sitemap-blog.xml         (когда блог появится)
```

Включение только: published + indexable + достаточный контент + connection_available (для городов).  
`lastmod` = `updated_at` записи при существенном изменении контента/SEO.  
`robots.txt` указывает на индекс.

---

## 9. Реферальные ссылки и аналитика

Приоритет без изменений:

1. city + type  
2. city  
3. type  
4. default  

CTA города/региональной страницы → `/go/register` с фиксацией `ReferralClick` (город, тип, landing, UTM).  
Клик ≠ регистрация.

Админ-дашборд (этап позже): визиты по URL-группам через существующие клики/лиды + UTM; IP-гео не использовать как факт.

---

## 10. Админка: города и SEO-диагностика

### `/admin/cities`

Фильтры: published / draft / connection / indexable / noindex / без Title / без Description / без unique_text.  
Редактирование: SEO, OG, FAQ, blocks, матрица типов, referral preview, preview страницы, publish readiness score (чек-лист, **не** гарантия позиций).

### `/admin/seo` (диагностика)

Проверки из п.15 ТЗ: пустые/дубли meta, noindex в sitemap, city без типов, нет referral, недостаточный контент.

### `/admin/seo_templates`

CRUD шаблонов + live preview со склонением.

---

## 11. Контент города

**Общие блоки** (частично reusable / partials): как устроиться, документы, общие условия.  
**Региональные:** availability, доступные типы, local FAQ, особенности, CTA.  

Страница города **не** может состоять только из подстановки названия — gate по `unique_text` + checklist готовности.

---

## 12. Риски SEO-дублей и митигация

| Риск | Митигация |
|------|-----------|
| Тонкие city×type на все комбинации | Только ручная публикация + is_indexable |
| Cookie-город дублирует контент | Canonical на `/`, городские URL отдельно |
| Смена slug | Авто 301 через Redirect |
| Индекс ссылается на draft | Index только indexable |
| Одинаковые Title | Диагностика дублей + ручные поля |
| Глобальный тип ≈ региональный | Разный H1/текст; региональный только при уникальном контенте |

---

## 13. План реализации (после согласования)

| Этап | Содержание | Оценка |
|------|------------|--------|
| A | Миграции: prepositional, is_indexable, CityCourierType, CityCourierPage, SeoTemplate; авто-redirect на slug change | 1 |
| B | Админка городов: матрица типов, SEO-поля, FAQ/blocks, фильтры, readiness | 1 |
| C | Публичный city show: только available types; index только indexable; перелинковка | 0.5 |
| D | CityCourierPagesController + admin + preview | 1 |
| E | SeoTemplate + применение без overwrite + диагностика `/admin/seo` | 1 |
| F | City picker на главной (cookie) + блок типов/CTA | 0.5 |
| G | Split sitemap + lastmod + robots | 0.5 |
| H | Перелинковка на courier_types#show (города с available) | 0.5 |
| I | Тесты (п.17 ТЗ) + seed Уфа/Казань и примеры | 1 |

**Не в первой волне:** полноценная посещаемость из Яндекс.Метрики в админке; блоковый visual editor уровня Notion — достаточно JSON blocks + textarea/FAQ как сейчас, с расширением полей.

---

## 14. Критерии приёмки (сжато)

Без деплоя кода админ может: добавить город → типы → контент → SEO → publish/noindex → referral → FAQ.  
Публичные URL стабильны, sitemap чистый, нет массовых пустых комбинаций, тесты п.17 зелёные.

---

## 15. Вопрос на согласование

Подтвердите, что можно переходить к **этапу 4** по плану A→I выше, с приоритетом:

1. City↔CourierType + усиление `/goroda/:slug/`  
2. SEO-шаблоны + склонение  
3. Региональные `/goroda/:city/:type/` только вручную  
4. City picker + split sitemap + диагностика  

Или скорректируйте scope (что отложить / что обязательно в первой поставке).
