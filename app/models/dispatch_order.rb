class DispatchOrder < ApplicationRecord
  include Sanitizable

  belongs_to :sales_order
  belongs_to :rental
  belongs_to :prepared_by
  has_many :dispatch_items, dependent: :destroy
  has_one :delivery_guide, dependent: :destroy
end
