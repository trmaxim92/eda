class RobotsController < ApplicationController
  def show
    render plain: <<~ROBOTS
      User-agent: *
      Allow: /
      Disallow: /admin/
      Disallow: /go/
      Disallow: /leads
      Disallow: /users/

      Sitemap: #{request.base_url}/sitemap.xml
    ROBOTS
  end
end
