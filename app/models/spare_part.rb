# app/models/spare_part.rb
class SparePart < ApplicationRecord
  include Sanitizable

  belongs_to :product, inverse_of: :spare_part
  belongs_to :spare_part_category

  has_many :spare_part_specs, dependent: :destroy
  has_many :spare_part_compatibilities, dependent: :destroy
  has_many :stock_movements, dependent: :destroy

  # Método para recalcular stock
  def calculated_stock
    stock_movements.where(movement_type: "IN").sum(:quantity) -
    stock_movements.where(movement_type: "OUT").sum(:quantity)
  end
end