# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_11_12_180001) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "cities", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "region"
    t.boolean "connection_available", default: false, null: false
    t.boolean "published", default: false, null: false
    t.text "unique_text"
    t.text "delivery_methods"
    t.text "connection_conditions"
    t.text "work_features"
    t.string "seo_title"
    t.string "seo_description"
    t.string "h1"
    t.string "canonical_url"
    t.string "robots_meta", default: "index,follow"
    t.string "og_title"
    t.string "og_description"
    t.jsonb "faq_items", default: [], null: false
    t.jsonb "blocks", default: [], null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name_in_prepositional"
    t.string "country", default: "RU", null: false
    t.string "short_description"
    t.boolean "is_indexable", default: true, null: false
    t.index ["is_indexable"], name: "index_cities_on_is_indexable"
    t.index ["published"], name: "index_cities_on_published"
    t.index ["slug"], name: "index_cities_on_slug", unique: true
  end

  create_table "city_courier_pages", force: :cascade do |t|
    t.bigint "city_id", null: false
    t.bigint "courier_type_id", null: false
    t.string "slug", null: false
    t.boolean "published", default: false, null: false
    t.boolean "is_indexable", default: false, null: false
    t.text "unique_text"
    t.text "short_description"
    t.jsonb "faq_items", default: [], null: false
    t.jsonb "blocks", default: [], null: false
    t.string "seo_title"
    t.string "seo_description"
    t.string "h1"
    t.string "canonical_url"
    t.string "robots_meta", default: "index,follow"
    t.string "og_title"
    t.string "og_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id", "courier_type_id"], name: "index_city_courier_pages_on_city_and_type", unique: true
    t.index ["city_id", "slug"], name: "index_city_courier_pages_on_city_and_slug", unique: true
    t.index ["city_id"], name: "index_city_courier_pages_on_city_id"
    t.index ["courier_type_id"], name: "index_city_courier_pages_on_courier_type_id"
    t.index ["is_indexable"], name: "index_city_courier_pages_on_is_indexable"
    t.index ["published"], name: "index_city_courier_pages_on_published"
  end

  create_table "city_courier_types", force: :cascade do |t|
    t.bigint "city_id", null: false
    t.bigint "courier_type_id", null: false
    t.boolean "available", default: false, null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id", "courier_type_id"], name: "index_city_courier_types_uniqueness", unique: true
    t.index ["city_id"], name: "index_city_courier_types_on_city_id"
    t.index ["courier_type_id"], name: "index_city_courier_types_on_courier_type_id"
  end

  create_table "courier_types", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "code", null: false
    t.text "description"
    t.text "features"
    t.text "requirements"
    t.text "documents"
    t.text "how_to_start"
    t.text "earnings_info"
    t.text "pros_cons"
    t.string "seo_title"
    t.string "seo_description"
    t.string "h1"
    t.string "canonical_url"
    t.string "robots_meta", default: "index,follow"
    t.string "og_title"
    t.string "og_description"
    t.boolean "published", default: true, null: false
    t.integer "position", default: 0, null: false
    t.jsonb "blocks", default: [], null: false
    t.jsonb "faq_items", default: [], null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_courier_types_on_code", unique: true
    t.index ["slug"], name: "index_courier_types_on_slug", unique: true
  end

  create_table "faqs", force: :cascade do |t|
    t.string "question", null: false
    t.text "answer", null: false
    t.string "group_name"
    t.string "page_scope", default: "home"
    t.boolean "published", default: true, null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_scope"], name: "index_faqs_on_page_scope"
    t.index ["published"], name: "index_faqs_on_published"
  end

  create_table "leads", force: :cascade do |t|
    t.string "name", null: false
    t.string "phone", null: false
    t.bigint "city_id"
    t.bigint "courier_type_id"
    t.string "city_name"
    t.string "courier_type_name"
    t.boolean "consent", default: false, null: false
    t.integer "status", default: 0, null: false
    t.text "admin_comment"
    t.string "landing_page"
    t.string "referrer"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_campaign"
    t.string "utm_content"
    t.string "utm_term"
    t.string "session_identifier"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_leads_on_city_id"
    t.index ["courier_type_id"], name: "index_leads_on_courier_type_id"
    t.index ["created_at"], name: "index_leads_on_created_at"
    t.index ["phone"], name: "index_leads_on_phone"
    t.index ["status"], name: "index_leads_on_status"
  end

  create_table "pages", force: :cascade do |t|
    t.string "title", null: false
    t.string "slug", null: false
    t.string "page_type", default: "content", null: false
    t.text "summary"
    t.text "body"
    t.jsonb "blocks", default: [], null: false
    t.boolean "published", default: false, null: false
    t.datetime "published_at"
    t.string "seo_title"
    t.string "seo_description"
    t.string "h1"
    t.string "canonical_url"
    t.string "robots_meta", default: "index,follow"
    t.string "og_title"
    t.string "og_description"
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_type"], name: "index_pages_on_page_type"
    t.index ["published"], name: "index_pages_on_published"
    t.index ["slug"], name: "index_pages_on_slug", unique: true
  end

  create_table "redirects", force: :cascade do |t|
    t.string "source_path", null: false
    t.string "target_path", null: false
    t.integer "redirect_type", default: 301, null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_redirects_on_active"
    t.index ["source_path"], name: "index_redirects_on_source_path", unique: true
  end

  create_table "referral_clicks", force: :cascade do |t|
    t.bigint "referral_link_id", null: false
    t.bigint "city_id"
    t.bigint "courier_type_id"
    t.string "landing_page"
    t.string "referrer"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_campaign"
    t.string "utm_content"
    t.string "utm_term"
    t.string "session_identifier"
    t.datetime "clicked_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_referral_clicks_on_city_id"
    t.index ["clicked_at"], name: "index_referral_clicks_on_clicked_at"
    t.index ["courier_type_id"], name: "index_referral_clicks_on_courier_type_id"
    t.index ["referral_link_id"], name: "index_referral_clicks_on_referral_link_id"
    t.index ["session_identifier"], name: "index_referral_clicks_on_session_identifier"
  end

  create_table "referral_links", force: :cascade do |t|
    t.string "name", null: false
    t.string "url", null: false
    t.bigint "city_id"
    t.bigint "courier_type_id"
    t.boolean "is_active", default: true, null: false
    t.boolean "is_default", default: false, null: false
    t.integer "priority", default: 0, null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_referral_links_on_city_id"
    t.index ["courier_type_id"], name: "index_referral_links_on_courier_type_id"
    t.index ["is_active"], name: "index_referral_links_on_is_active"
    t.index ["is_default"], name: "index_referral_links_on_is_default"
  end

  create_table "reviews", force: :cascade do |t|
    t.string "author_name", null: false
    t.bigint "city_id"
    t.bigint "courier_type_id"
    t.string "city_name"
    t.string "courier_type_name"
    t.text "body", null: false
    t.date "reviewed_on"
    t.boolean "published", default: false, null: false
    t.boolean "moderated", default: false, null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_reviews_on_city_id"
    t.index ["courier_type_id"], name: "index_reviews_on_courier_type_id"
    t.index ["published"], name: "index_reviews_on_published"
  end

  create_table "seo_templates", force: :cascade do |t|
    t.string "scope", null: false
    t.string "name", null: false
    t.string "title_template", null: false
    t.string "description_template", null: false
    t.string "h1_template", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["scope"], name: "index_seo_templates_on_scope"
  end

  create_table "site_settings", force: :cascade do |t|
    t.string "key", null: false
    t.text "value"
    t.string "value_type", default: "string", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_site_settings_on_key", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.integer "role", default: 3, null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "city_courier_pages", "cities"
  add_foreign_key "city_courier_pages", "courier_types"
  add_foreign_key "city_courier_types", "cities"
  add_foreign_key "city_courier_types", "courier_types"
  add_foreign_key "leads", "cities"
  add_foreign_key "leads", "courier_types"
  add_foreign_key "referral_clicks", "cities"
  add_foreign_key "referral_clicks", "courier_types"
  add_foreign_key "referral_clicks", "referral_links"
  add_foreign_key "referral_links", "cities"
  add_foreign_key "referral_links", "courier_types"
  add_foreign_key "reviews", "cities"
  add_foreign_key "reviews", "courier_types"
end
