class CreatePages < ActiveRecord::Migration[8.1]
  def change
    create_table :pages do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.string :page_type, null: false, default: "content"
      t.text :summary
      t.text :body
      t.jsonb :blocks, null: false, default: []
      t.boolean :published, null: false, default: false
      t.datetime :published_at
      t.string :seo_title
      t.string :seo_description
      t.string :h1
      t.string :canonical_url
      t.string :robots_meta, default: "index,follow"
      t.string :og_title
      t.string :og_description
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :pages, :slug, unique: true
    add_index :pages, :page_type
    add_index :pages, :published
  end
end
