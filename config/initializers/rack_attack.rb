class Rack::Attack
  throttle("leads/ip", limit: 5, period: 10.minutes) do |req|
    req.ip if req.path == "/leads" && req.post?
  end

  throttle("register/ip", limit: 30, period: 1.minute) do |req|
    req.ip if req.path.start_with?("/go/register")
  end

  self.throttled_responder = lambda do |_env|
    [ 429, { "Content-Type" => "text/plain; charset=utf-8" }, [ "Слишком много запросов. Попробуйте позже." ] ]
  end
end
