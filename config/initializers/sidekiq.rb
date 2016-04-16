require 'sidekiq'

Sidekiq.configure_server do |config|
  config.redis = { namespace: 'ansel' }
end

Sidekiq.configure_client do |config|
  config.redis = { namespace: 'ansel' }
end
