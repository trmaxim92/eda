class CreateCourierTypes < ActiveRecord::Migration[8.1]
  def change
    create_table :courier_types do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :code, null: false
      t.text :description
      t.text :features
      t.text :requirements
      t.text :documents
      t.text :how_to_start
      t.text :earnings_info
      t.text :pros_cons
      t.string :seo_title
      t.string :seo_description
      t.string :h1
      t.string :canonical_url
      t.string :robots_meta, default: "index,follow"
      t.string :og_title
      t.string :og_description
      t.boolean :published, null: false, default: true
      t.integer :position, null: false, default: 0
      t.jsonb :blocks, null: false, default: []
      t.jsonb :faq_items, null: false, default: []

      t.timestamps
    end

    add_index :courier_types, :slug, unique: true
    add_index :courier_types, :code, unique: true
  end
end
