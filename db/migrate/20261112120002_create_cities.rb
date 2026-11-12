class CreateCities < ActiveRecord::Migration[8.1]
  def change
    create_table :cities do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :region
      t.boolean :connection_available, null: false, default: false
      t.boolean :published, null: false, default: false
      t.text :unique_text
      t.text :delivery_methods
      t.text :connection_conditions
      t.text :work_features
      t.string :seo_title
      t.string :seo_description
      t.string :h1
      t.string :canonical_url
      t.string :robots_meta, default: "index,follow"
      t.string :og_title
      t.string :og_description
      t.jsonb :faq_items, null: false, default: []
      t.jsonb :blocks, null: false, default: []

      t.timestamps
    end

    add_index :cities, :slug, unique: true
    add_index :cities, :published
  end
end
