class WorkOrderPart < ApplicationRecord
  include Sanitizable

  belongs_to :work_order
  belongs_to :product
end
