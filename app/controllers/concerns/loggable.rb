module Loggable
  extend ActiveSupport::Concern

  def log_activity(action, note = nil, user = nil)
    ActivityLog.create!(
      user: user || (respond_to?(:current_user) ? current_user : nil),
      action: action,
      browser: request.user_agent,
      ip_address: request.remote_ip,
      note: note
    )
  rescue StandardError => e
    Rails.logger.error "Error guardando ActivityLog: #{e.message}"
  end
end
