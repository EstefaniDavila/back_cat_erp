# app/models/error_report.rb
class ErrorReport < ApplicationRecord
  include Sanitizable

  # ---------------------------------------------------------------------------
  # Asociaciones
  # ---------------------------------------------------------------------------
  belongs_to :reported_by, class_name: "User"
  belongs_to :reviewed_by, class_name: "User", optional: true

  # ---------------------------------------------------------------------------
  # Enums (más limpio y funcional)
  # ---------------------------------------------------------------------------
  enum status: {
    pending: "pending",
    accepted: "accepted", 
    rejected: "rejected"
  }

  enum severity: {
    critical: "critical",
    high: "high",
    medium: "medium",
    low: "low"
  }

  enum change_type: {
    emergency: "emergency",
    normal: "normal",
    standard: "standard"
  }

  enum module_affected: {
    sales: "sales",
    rentals: "rentals",
    maintenance: "maintenance",
    inventory: "inventory",
    dispatch: "dispatch",
    products: "products",
    clients: "clients",
    leads: "leads",
    other: "other"
  }

  # ---------------------------------------------------------------------------
  # Constantes (solo lo que no es enum)
  # ---------------------------------------------------------------------------
  CHANGE_TYPE_PREFIXES = {
    "emergency" => "CHE",
    "normal"    => "CHN",
    "standard"  => "CHS"
  }.freeze

  # ---------------------------------------------------------------------------
  # Validaciones (simplificadas porque enum ya valida)
  # ---------------------------------------------------------------------------
  validates :title, presence: true, length: { maximum: 255 }
  validates :description, presence: true
  validates :change_code, uniqueness: true, allow_nil: true
  validates :change_type, presence: true, if: -> { accepted? }

  # ---------------------------------------------------------------------------
  # Scopes (enum ya provee: pending, accepted, rejected, etc.)
  # ---------------------------------------------------------------------------
  scope :recent, -> { order(created_at: :desc) }

  # ---------------------------------------------------------------------------
  # Estado helpers (enum ya provee: pending?, accepted?, rejected?)
  # ---------------------------------------------------------------------------

  # ---------------------------------------------------------------------------
  # Acciones de negocio
  # ---------------------------------------------------------------------------

  def accept!(reviewed_by_id:, change_type:, admin_notes: nil)
    raise ArgumentError, "change_type inválido" unless self.class.change_types.key?(change_type)

    assign_attributes(
      status: :accepted,
      change_type: change_type,
      change_code: generate_change_code(change_type),
      admin_notes: admin_notes,
      reviewed_by_id: reviewed_by_id,
      reviewed_at: Time.current
    )
    save!
    create_jira_ticket
  end

  def create_jira_ticket
    return if jira_issue_key.present?
    JiraService.new(self).create_issue
  rescue StandardError => e
    Rails.logger.error("[ErrorReport] Falló creación en Jira: #{e.message}")
  end

  def reject!(reviewed_by_id:, admin_notes: nil)
    assign_attributes(
      status: :rejected,
      admin_notes: admin_notes,
      reviewed_by_id: reviewed_by_id,
      reviewed_at: Time.current
    )
    save!
    self
  end

  def refresh_jira_status!
    return unless jira_issue_key.present?
    
    response = HTTParty.get(
      "#{ENV['JIRA_URL']}/rest/api/3/issue/#{jira_issue_key}",
      headers: { 'Authorization' => "Basic #{Base64.strict_encode64("#{ENV['JIRA_EMAIL']}:#{ENV['JIRA_API_TOKEN']}")}" }
    )
    
    if response.code == 200
      status = JSON.parse(response.body)['fields']['status']['name']
      update(jira_status: status)
    end
  rescue StandardError => e
    Rails.logger.warn("[ErrorReport#refresh_jira_status!] #{e.message}")
  end

  private

  def generate_change_code(type)
    prefix = CHANGE_TYPE_PREFIXES[type]
    last_code = ErrorReport
                  .where("change_code LIKE ?", "#{prefix}-%")
                  .order(:change_code)
                  .pluck(:change_code)
                  .last

    next_number = last_code ? last_code.split("-").last.to_i + 1 : 1
    format("#{prefix}-%03d", next_number)
  end
end