module Admin
  class SeoController < BaseController
    def show
      authorize :seo, :show?
      @issues = []

      City.find_each do |city|
        label = "Город #{city.name}"
        @issues << "#{label}: пустой Title" if city.seo_title.blank?
        @issues << "#{label}: пустой Description" if city.seo_description.blank?
        @issues << "#{label}: пустой H1" if city.h1.blank?
        @issues << "#{label}: мало уникального контента" if city.unique_text.to_s.strip.length < 200
        @issues << "#{label}: нет доступных типов" if city.published? && city.available_courier_types.none?
        @issues << "#{label}: published но не indexable" if city.published? && !city.indexable?
      end

      titles = City.where.not(seo_title: [ nil, "" ]).group(:seo_title).having("count(*) > 1").count
      titles.each_key { |t| @issues << "Дублирующий Title: #{t}" }

      descriptions = City.where.not(seo_description: [ nil, "" ]).group(:seo_description).having("count(*) > 1").count
      descriptions.each_key { |d| @issues << "Дублирующий Description: #{d.to_s.truncate(80)}" }

      CityCourierPage.find_each do |page|
        if page.published? && !page.indexable?
          @issues << "Рег. страница #{page.city.name}/#{page.slug}: опубликована, но не indexable"
        end
      end
    end
  end
end
