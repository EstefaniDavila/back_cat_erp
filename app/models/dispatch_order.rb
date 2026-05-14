# app/models/dispatch_order.rb
class DispatchOrder < ApplicationRecord
  include Sanitizable

  belongs_to :sales_order, optional: true
  belongs_to :rental, optional: true
  belongs_to :prepared_by, class_name: 'User'
  has_many :dispatch_items, dependent: :destroy
  has_one :delivery_guide, dependent: :destroy

  accepts_nested_attributes_for :dispatch_items, allow_destroy: true

  validates :code, uniqueness: true, allow_nil: true
  validates :status, presence: true, inclusion: { in: %w[pending dispatched delivered cancelled] }

  before_validation :generate_code, on: :create
  after_update :update_vehicle_status

  enum status: {
    pending: 'pending',
    dispatched: 'dispatched',
    delivered: 'delivered',
    cancelled: 'cancelled'
  }

  def pending?
    status == 'pending'
  end

  def dispatched?
    status == 'dispatched'
  end

  def delivered?
    status == 'delivered'
  end

  private

  def update_vehicle_status
    case status
    when 'delivered'
      handle_delivered_vehicle
    when 'cancelled'
      handle_cancelled_vehicle
    end
  end

  def handle_delivered_vehicle
    vehicle = get_vehicle_from_dispatch_items
    
    if vehicle.present?
      if rental.present?
        vehicle.mark_as_rented! if vehicle.available?
      elsif sales_order.present?
        vehicle.mark_as_sold! if vehicle.available?
      end
    end

    dispatch_items.each do |item|
      if item.product.product_type == 'spare_part' && item.product.spare_part.present?
        spare_part = item.product.spare_part
        stock_disponible = spare_part.calculated_stock
        
        if item.quantity > stock_disponible
          raise "Stock insuficiente para #{spare_part.part_number}. Disponible: #{stock_disponible}, Solicitado: #{item.quantity}"
        end
        
        StockMovement.create!(
          spare_part: spare_part,
          movement_type: 'out',
          quantity: item.quantity,
          performed_by: prepared_by,
          reference: "Venta - Orden: #{code}"
        )

         spare_part.update(stock: spare_part.stock - item.quantity)

      end
    end
  end

  def handle_cancelled_vehicle
    if rental.present?
      vehicle = rental.vehicle
      if vehicle && vehicle.rented?
        vehicle.mark_as_returned!
      end
    end
  end

  def get_vehicle_from_dispatch_items
    dispatch_items.each do |item|
      if item.product.product_type == 'vehicle' && item.product.vehicle.present?
        return item.product.vehicle
      end
    end
    nil
  end

  def generate_code
    return if code.present?
    self.code = "DISP-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.hex(4).upcase}"
  end
end