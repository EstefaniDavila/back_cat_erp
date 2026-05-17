class Quotation < ApplicationRecord
  include CodeGenerator
  include Sanitizable
  has_paper_trail

  before_validation :generate_unique_code_custom, on: :create, if: -> { code.blank? }

  def generate_unique_code_custom
    prefix = "COT"
    year = Time.current.year
    last_quotation = Quotation.unscoped.where("code LIKE ?", "#{prefix}-#{year}-%").order(code: :desc).first
    next_number = 1
    if last_quotation
      last_num = last_quotation.code.split('-').last.to_i
      next_number = last_num + 1
    end
    self.code = "#{prefix}-#{year}-#{next_number.to_s.rjust(5, '0')}"
  end

  belongs_to :client
  belongs_to :advisor, optional: true
  belongs_to :lead, optional: true
  has_many :quotation_items, dependent: :destroy
  has_many :quotation_comments, dependent: :destroy
  has_many :quotation_status_histories, dependent: :destroy
  has_many :quotation_files, dependent: :destroy
  has_one :sales_order, dependent: :destroy
  has_one :rental, dependent: :destroy
  has_one :maintenance, dependent: :destroy
  has_many :area_requests, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    ["code", "quotation_type", "status", "subtotal", "total", "valid_until"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["client", "advisor", "lead"]
  end

  # Función mágica para aceptar la cotización y generar la orden
  def accept_and_generate_order!
    return false if status == 'client_accepted'

    ActiveRecord::Base.transaction do
      update!(status: 'client_accepted', approved_at: Time.current)
      
      if quotation_type == 'sale' || quotation_type == 'spare_parts'
        create_sales_order!(
          code: "SO-#{code}",
          status: 'pending',
          total: total,
          client_id: client_id,
          advisor_id: advisor_id
        )
      elsif quotation_type == 'rental'
        create_rental!(
          code: "RNT-#{code}",
          status: 'pending',
          total: total,
          start_date: Time.current, # Por defecto hoy, el admin de rentals lo cambia
          end_date: Time.current + 30.days,
          client_id: client_id,
          vehicle_id: quotation_items.first&.product_id # Asumiendo que el primer item es el vehículo
        )
      elsif quotation_type == 'maintenance'
        if maintenance.present?
          maintenance.update!(status: 'approved_for_repair')
        else
          create_maintenance!(
            code: "MNT-#{code}",
            status: 'pending',
            maintenance_type: 'corrective',
            client_id: client_id,
            requested_at: Time.current
          )
        end
      end
    end
    true
  end
end
