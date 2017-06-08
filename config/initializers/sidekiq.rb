Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{ENV.fetch("REDIS_SERVICE_HOST") { "localhost" }}:#{ENV.fetch("REDIS_SERVICE_PORT") { "6379" }}/" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{ENV.fetch("REDIS_SERVICE_HOST") { "localhost" }}:#{ENV.fetch("REDIS_SERVICE_PORT") { "6379" }}/" }
end
