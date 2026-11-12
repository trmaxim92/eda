class CreateLeads < ActiveRecord::Migration[8.1]
  def change
    create_table :leads do |t|
      t.string :name, null: false
      t.string :phone, null: false
      t.references :city, foreign_key: true
      t.references :courier_type, foreign_key: true
      t.string :city_name
      t.string :courier_type_name
      t.boolean :consent, null: false, default: false
      t.integer :status, null: false, default: 0
      t.text :admin_comment
      t.string :landing_page
      t.string :referrer
      t.string :utm_source
      t.string :utm_medium
      t.string :utm_campaign
      t.string :utm_content
      t.string :utm_term
      t.string :session_identifier
      t.string :ip_address

      t.timestamps
    end

    add_index :leads, :status
    add_index :leads, :phone
    add_index :leads, :created_at
  end
end
