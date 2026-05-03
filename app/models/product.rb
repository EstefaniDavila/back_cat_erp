class Product < ApplicationRecord
  include CodeGenerator
  include Sanitizable

  belongs_to :created_by
  belongs_to :updated_by
  has_many :vehicles, dependent: :destroy
  has_many :spare_parts, dependent: :destroy
  has_many :product_images, dependent: :destroy
  has_many :quotation_items
  has_many :work_order_parts
  has_many :dispatch_items
  has_many :supplier_products
end
