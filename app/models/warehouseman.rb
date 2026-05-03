class Warehouseman < ApplicationRecord
  include Sanitizable

  has_one :user, as: :roleable, dependent: :destroy
end
