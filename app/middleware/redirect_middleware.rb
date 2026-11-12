class RedirectMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    path = request.path.chomp("/").presence || "/"

    redirect = find_redirect(path)
    if redirect
      return [ redirect.status_code, { "Location" => redirect.target_path, "Content-Type" => "text/html" }, [ "Redirecting..." ] ]
    end

    @app.call(env)
  rescue ActiveRecord::StatementInvalid, ActiveRecord::ConnectionNotEstablished
    @app.call(env)
  end

  private

  def find_redirect(path)
    return nil unless defined?(Redirect) && ActiveRecord::Base.connection.data_source_exists?("redirects")

    Redirect.active.find_by(source_path: [ path, "#{path}/", "/#{path.delete_prefix('/')}" ].uniq)
  end
end
