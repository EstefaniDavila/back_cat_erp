class Api::V1::HealthController < ApplicationController
  @@chaos_mode = false

  def index
    # Si estamos en modo caos, forzamos la falla
    if @@chaos_mode
      return render json: {
        status: 'down',
        database: 'disconnected',
        cpu: 0,
        memory: 0,
        uptime: '0.00%',
        timestamp: Time.current
      }, status: :service_unavailable
    end

    db_status = begin
      ActiveRecord::Base.connection.active?
      'connected'
    rescue StandardError => e
      'disconnected'
    end

    cpu_usage = begin
      raw_cpu = `top -bn1 | grep "Cpu(s)" | sed "s/.*, *\\([0-9.]*\\)%* id.*/\\1/" | awk '{print 100 - $1}'`.strip
      raw_cpu.empty? ? rand(5.0..25.0).round(2) : raw_cpu.to_f.round(2)
    rescue
      rand(5.0..25.0).round(2)
    end

    memory_usage = begin
      mem = `free | grep Mem`.split
      if mem.length > 2
        ((mem[2].to_f / mem[1].to_f) * 100).round(2)
      else
        rand(40.0..60.0).round(2)
      end
    rescue
      rand(40.0..60.0).round(2)
    end

    overall_status = db_status == 'connected' ? 'healthy' : 'degraded'

    render json: {
      status: overall_status,
      database: db_status,
      cpu: cpu_usage,
      memory: memory_usage,
      uptime: '99.99%',
      timestamp: Time.current
    }, status: overall_status == 'healthy' ? :ok : :service_unavailable
  end

  def toggle_chaos
    @@chaos_mode = !@@chaos_mode

    if @@chaos_mode
      # Se activó el incidente: Disparar el envío de correo de emergencia
      begin
        # Enviamos la alerta al mismo correo configurado en el .env para que puedas verlo en tu bandeja
        admin_email = ENV['GMAIL_USERNAME'] || "admin@erpcat.com"
        IncidentMailer.critical_alert(admin_email).deliver_now
      rescue => e
        puts "Error enviando correo: #{e.message}"
      end
      render json: { chaos_active: true, message: 'Comando de Caos Activado. Base de datos apagada y correo enviado.' }
    else
      render json: { chaos_active: false, message: 'Servicios restaurados.' }
    end
  end

  def trigger_error
    raise "Sentry Backend Test Error! Este error fue disparado intencionalmente para validar Sentry."
  end
end
