Rails.configuration.x.redis.host = ENV.fetch("REDIS_SERVICE_HOST") { "localhost" }
Rails.configuration.x.redis.port = ENV.fetch("REDIS_SERVICE_PORT") { "6379" }
Rails.configuration.x.redis.uri =
  "redis://#{Rails.configuration.x.redis.host}:#{Rails.configuration.x.redis.port}"

Sidekiq.configure_server do |config|
  config.redis = { url: Rails.configuration.x.redis.uri }
end

Sidekiq.configure_client do |config|
  config.redis = { url: Rails.configuration.x.redis.uri }
end
