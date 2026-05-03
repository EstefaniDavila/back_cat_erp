class SparePartCategory < ApplicationRecord
  include Sanitizable

  has_many :spare_parts, dependent: :destroy
end
