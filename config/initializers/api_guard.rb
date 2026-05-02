ApiGuard.setup do |config|
  config.token_validity = 1.day
  config.refresh_token_validity = 1.week
  config.blacklist_token_after_refreshing = true
end