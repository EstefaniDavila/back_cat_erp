class Quotation < ApplicationRecord
  include CodeGenerator
  include Sanitizable

  belongs_to :client
  belongs_to :advisor
  belongs_to :lead
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
