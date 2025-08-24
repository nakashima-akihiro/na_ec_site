sidekiq_config = {
  url: ENV.fetch('REDIS_URL') { 'redis://redis:6379/1' },
  ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_PEER }
}

Sidekiq.configure_server do |config|
  config.redis = sidekiq_config
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_config
end
