# app/models/purchase_order.rb
class PurchaseOrder < ApplicationRecord
  include Sanitizable

  belongs_to :supplier
  belongs_to :requested_by, class_name: 'User'
  has_many :purchase_order_items, dependent: :destroy

  accepts_nested_attributes_for :purchase_order_items, allow_destroy: true, reject_if: :all_blank

  validates :code, uniqueness: true, allow_nil: true
  validates :supplier_id, :requested_by_id, presence: true
  validates :status, presence: true, inclusion: { in: %w[draft sent partially_received completed cancelled] }

  before_validation :generate_code, on: :create
  after_save :recalculate_total  

  after_update :register_stock_movements, if: :just_received?

  enum status: {
    draft: 'draft',
    sent: 'sent',
    partially_received: 'partially_received',
    completed: 'completed',
    cancelled: 'cancelled'
  }

  

  def draft?
    status == 'draft'
  end
  
  def receive!
  update!(status: 'completed', received_at: Time.current)
  end
  def just_received?
    saved_change_to_status? && status == "completed"
  end

  private

   def register_stock_movements
    purchase_order_items.each do |item|
      spare_part = item.spare_part

      next unless spare_part # evita errores si no existe

      # 🔹 Crear movimiento
      StockMovement.create!(
        movement_type: "IN",
        quantity: item.quantity,
        reference: self.code,
        spare_part: spare_part,
        performed_by: requested_by
      )

      # 🔹 Actualizar stock físico
      spare_part.increment!(:stock, item.quantity)
    end
  end

  def generate_code
    return if code.present?
    self.code = "PO-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.hex(4).upcase}"
  end

  def recalculate_total 
    update_column(:total, purchase_order_items.sum(:total_cost))
  end
end