class DatabaseBackupJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info "Iniciando Job de Backup Automático..."
    require 'rake'
    Rails.application.load_tasks if Rake::Task.tasks.empty?
    Rake::Task['db:backup'].reenable # Permite volver a correrlo si el proceso no muere
    Rake::Task['db:backup'].invoke
  rescue StandardError => e
    Rails.logger.error "Error en DatabaseBackupJob: #{e.message}"
  end
end
