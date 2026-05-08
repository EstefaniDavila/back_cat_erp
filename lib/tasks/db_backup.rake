namespace :db do
  desc "Genera un backup completo de la base de datos PostgreSQL"
  task backup: :environment do
    backup_dir = Rails.root.join('storage', 'backups')
    FileUtils.mkdir_p(backup_dir) unless Dir.exist?(backup_dir)

    db_config = ActiveRecord::Base.connection_db_config.configuration_hash
    db_name = db_config[:database]
    db_user = db_config[:username]
    db_pass = db_config[:password]
    db_host = db_config[:host] || 'localhost'

    timestamp = Time.now.strftime('%Y%m%d_%H%M%S')
    backup_file = backup_dir.join("#{db_name}_#{timestamp}.sql.gz")

    puts " Iniciando backup de #{db_name}..."

    # Comando pg_dump inyectando la contraseña temporalmente
    command = "PGPASSWORD='#{db_pass}' pg_dump -h #{db_host} -U #{db_user} #{db_name} | gzip > #{backup_file}"
    
    if system(command)
      puts "✅ Backup completado exitosamente: #{backup_file}"
      
      # Limpieza: Borrar backups de más de 7 días
      Dir.glob(backup_dir.join('*.sql.gz')).each do |file|
        if File.mtime(file) < 7.days.ago
          File.delete(file)
          puts " Backup antiguo eliminado: #{File.basename(file)}"
        end
      end
    else
      puts " Error al generar el backup."
    end
  end
end
