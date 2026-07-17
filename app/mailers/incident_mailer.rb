class IncidentMailer < ApplicationMailer
  default from: 'monitor@erpcat.com'

  def critical_alert(admin_email)
    @time = Time.current.strftime("%d/%m/%Y %H:%M:%S")
    @server_ip = "DigitalOcean VPS (142.12.33.1)"
    
    # Adjuntar el manual de contingencia al correo
    file_path = Rails.root.join('public', 'Manual_Contingencia_ERP_CAT.docx')
    attachments['Plan_de_Contingencia_ERP_CAT.docx'] = File.read(file_path) if File.exist?(file_path)

    mail(to: admin_email, subject: '[URGENTE] ALERTA CRÍTICA - Caída de Base de Datos Principal')
  end
end
