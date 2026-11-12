namespace :content do
  desc "Refresh public copy, courier types, FAQs and calculator rates from seeds logic"
  task refresh: :environment do
    load Rails.root.join("db/seeds.rb")
    puts "Content refreshed"
  end
end
