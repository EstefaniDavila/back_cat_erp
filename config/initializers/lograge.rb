Rails.application.configure do
  config.lograge.enabled = true

  # Mantener los logs limpios y en una sola línea
  config.lograge.formatter = Lograge::Formatters::Json.new

  # Agregar información útil a cada log (como el ID del usuario si existe)
  config.lograge.custom_payload do |controller|
    {
      host: controller.request.host,
      user_id: controller.try(:current_user).try(:id)
    }
  end
end
