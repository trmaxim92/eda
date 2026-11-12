class CreateReviews < ActiveRecord::Migration[8.1]
  def change
    create_table :reviews do |t|
      t.string :author_name, null: false
      t.references :city, foreign_key: true
      t.references :courier_type, foreign_key: true
      t.string :city_name
      t.string :courier_type_name
      t.text :body, null: false
      t.date :reviewed_on
      t.boolean :published, null: false, default: false
      t.boolean :moderated, null: false, default: false
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :reviews, :published
  end
end
