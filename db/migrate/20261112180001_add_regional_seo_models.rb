class AddRegionalSeoModels < ActiveRecord::Migration[8.1]
  def change
    change_table :cities, bulk: true do |t|
      t.string :name_in_prepositional
      t.string :country, default: "RU", null: false
      t.string :short_description
      t.boolean :is_indexable, default: true, null: false
    end
    add_index :cities, :is_indexable

    create_table :city_courier_types do |t|
      t.references :city, null: false, foreign_key: true
      t.references :courier_type, null: false, foreign_key: true
      t.boolean :available, default: false, null: false
      t.text :notes
      t.timestamps
    end
    add_index :city_courier_types, [ :city_id, :courier_type_id ], unique: true, name: "index_city_courier_types_uniqueness"

    create_table :city_courier_pages do |t|
      t.references :city, null: false, foreign_key: true
      t.references :courier_type, null: false, foreign_key: true
      t.string :slug, null: false
      t.boolean :published, default: false, null: false
      t.boolean :is_indexable, default: false, null: false
      t.text :unique_text
      t.text :short_description
      t.jsonb :faq_items, default: [], null: false
      t.jsonb :blocks, default: [], null: false
      t.string :seo_title
      t.string :seo_description
      t.string :h1
      t.string :canonical_url
      t.string :robots_meta, default: "index,follow"
      t.string :og_title
      t.string :og_description
      t.timestamps
    end
    add_index :city_courier_pages, [ :city_id, :slug ], unique: true, name: "index_city_courier_pages_on_city_and_slug"
    add_index :city_courier_pages, [ :city_id, :courier_type_id ], unique: true, name: "index_city_courier_pages_on_city_and_type"
    add_index :city_courier_pages, :published
    add_index :city_courier_pages, :is_indexable

    create_table :seo_templates do |t|
      t.string :scope, null: false
      t.string :name, null: false
      t.string :title_template, null: false
      t.string :description_template, null: false
      t.string :h1_template, null: false
      t.boolean :active, default: true, null: false
      t.timestamps
    end
    add_index :seo_templates, :scope
  end
end
