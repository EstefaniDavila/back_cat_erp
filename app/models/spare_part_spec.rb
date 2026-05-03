class SparePartSpec < ApplicationRecord
  include Sanitizable

  belongs_to :spare_part
end
