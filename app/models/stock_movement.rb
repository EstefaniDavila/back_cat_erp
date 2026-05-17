# app/models/stock_movement.rb
class StockMovement < ApplicationRecord
  include Sanitizable

  belongs_to :spare_part
  belongs_to :performed_by, class_name: 'User'

  # ENUM para evitar errores
  enum movement_type: {
    in: "IN",
    out: "OUT"
  }

  # Validaciones
  validates :movement_type, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }

  validate :no_negative_stock

  private

  def no_negative_stock
    return unless movement_type == "OUT"

    current_stock = spare_part.stock

    if quantity > current_stock
      errors.add(:quantity, "excede el stock disponible")
    end
  end
end