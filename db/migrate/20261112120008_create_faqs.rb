class CreateFaqs < ActiveRecord::Migration[8.1]
  def change
    create_table :faqs do |t|
      t.string :question, null: false
      t.text :answer, null: false
      t.string :group_name
      t.string :page_scope, default: "home"
      t.boolean :published, null: false, default: true
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :faqs, :page_scope
    add_index :faqs, :published
  end
end
