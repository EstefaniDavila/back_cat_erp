class SparePart < ApplicationRecord
  include Sanitizable

  belongs_to :product
  belongs_to :spare_part_category
  has_many :spare_part_specs, dependent: :destroy
  has_many :spare_part_compatibilities, dependent: :destroy
  has_many :stock_movements, dependent: :destroy
end
