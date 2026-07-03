class IncidentMailer < ApplicationMailer
  default from: 'monitor@erpcat.com'

  def critical_alert(admin_email)
    @time = Time.current.strftime("%d/%m/%Y %H:%M:%S")
    @server_ip = "DigitalOcean VPS (142.12.33.1)"
    mail(to: admin_email, subject: '[URGENTE] ALERTA CRÍTICA - Caída de Base de Datos Principal')
  end
end
