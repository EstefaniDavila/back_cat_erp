class ProductImage < ApplicationRecord
  include Sanitizable
  belongs_to :product

  validate :one_image_per_product, on: :create

  private

  def one_image_per_product
    if product&.product_images&.count >= 1
      errors.add(:base, "El producto ya tiene una imagen")
    end
  end
end