class SitemapsController < ApplicationController
  def show
    @pages = Page.published.where.not(robots_meta: [ "noindex,follow", "noindex,nofollow" ])
    @cities = City.published.available.select(&:indexable?)
    @courier_types = CourierType.published
    @static_paths = %w[/ /rabota-v-yandex-eda/ /rabota-kurerom/ /usloviya-raboty/ /rabota-cherez-park/ /otzyvy/ /goroda/ /kontakty/]

    respond_to do |format|
      format.xml
    end
  end
end
