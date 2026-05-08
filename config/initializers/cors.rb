Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'
    resource '*', 
      headers: :any, 
      methods: %i[get post put patch delete options head],
      expose: ['Authorization', 'access-token', 'expiry', 'client', 'uid'] # Útil para JWT o Auth
  end
end