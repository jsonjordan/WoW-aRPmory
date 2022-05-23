# frozen_string_literal: true

# Redis.current = Redis.new(url:  ENV['REDIS_URL'],
#                           port: ENV['REDIS_PORT'].to_i,
#                           db:   ENV['REDIS_DB'].to_i)

# Redis.current = Redis.new(url: ENV["REDISTOGO_URL"], ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE })

$redis = Redis.new(url: ENV["REDIS_URL"], ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE })