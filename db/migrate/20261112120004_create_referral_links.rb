class CreateReferralLinks < ActiveRecord::Migration[8.1]
  def change
    create_table :referral_links do |t|
      t.string :name, null: false
      t.string :url, null: false
      t.references :city, foreign_key: true
      t.references :courier_type, foreign_key: true
      t.boolean :is_active, null: false, default: true
      t.boolean :is_default, null: false, default: false
      t.integer :priority, null: false, default: 0
      t.text :description

      t.timestamps
    end

    add_index :referral_links, :is_default
    add_index :referral_links, :is_active
  end
end
