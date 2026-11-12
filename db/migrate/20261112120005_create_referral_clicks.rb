class CreateReferralClicks < ActiveRecord::Migration[8.1]
  def change
    create_table :referral_clicks do |t|
      t.references :referral_link, null: false, foreign_key: true
      t.references :city, foreign_key: true
      t.references :courier_type, foreign_key: true
      t.string :landing_page
      t.string :referrer
      t.string :utm_source
      t.string :utm_medium
      t.string :utm_campaign
      t.string :utm_content
      t.string :utm_term
      t.string :session_identifier
      t.datetime :clicked_at, null: false

      t.timestamps
    end

    add_index :referral_clicks, :clicked_at
    add_index :referral_clicks, :session_identifier
  end
end
