class AddCityCatalogAndDeclensions < ActiveRecord::Migration[8.1]
  def change
    change_table :cities, bulk: true do |t|
      t.boolean :is_featured, default: false, null: false
      t.integer :sort_order, default: 0, null: false
      t.string :name_genitive
      t.string :name_dative
      t.datetime :content_updated_at
    end

    add_index :cities, :is_featured
    add_index :cities, :sort_order
  end
end
