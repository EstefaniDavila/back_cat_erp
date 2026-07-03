Sentry.init do |config|
  # Aquí va el DSN de tu proyecto Sentry para el Backend. 
  # He colocado el mismo que usaste en el Frontend, pero si creaste un proyecto distinto en Sentry para Ruby, solo cámbialo aquí.
  config.dsn = 'https://07d2721451db39cab39d7db2b886294d@o4511669773795328.ingest.us.sentry.io/4511669950349312'
  
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # Set traces_sample_rate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production.
  config.traces_sample_rate = 1.0
  
  # Opcional: Ignorar algunos errores comunes que no son críticos
  config.excluded_exceptions += ['ActionController::RoutingError', 'ActiveRecord::RecordNotFound']
end
