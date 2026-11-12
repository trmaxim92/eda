class CreateRedirects < ActiveRecord::Migration[8.1]
  def change
    create_table :redirects do |t|
      t.string :source_path, null: false
      t.string :target_path, null: false
      t.integer :redirect_type, null: false, default: 301
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :redirects, :source_path, unique: true
    add_index :redirects, :active
  end
end
