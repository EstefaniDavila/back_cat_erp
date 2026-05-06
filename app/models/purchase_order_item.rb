# app/models/purchase_order_item.rb
class PurchaseOrderItem < ApplicationRecord
  include Sanitizable

  belongs_to :purchase_order
  belongs_to :product

  before_save :calculate_total_cost

  # Validaciones
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :unit_cost, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :product_id, uniqueness: { scope: :purchase_order_id, message: "already added to this order" }

  # Callbacks
  before_validation :calculate_total_cost, on: [:create, :update]
  before_save :set_received_quantity_default

  private

  def calculate_total_cost
    self.total_cost = quantity.to_d * unit_cost.to_d if quantity.present? && unit_cost.present?
  end

  def set_received_quantity_default  
    self.received_quantity ||= 0
  end

end