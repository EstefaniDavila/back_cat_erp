class WorkOrderAction < ApplicationRecord
  include Sanitizable

  belongs_to :work_order
  belongs_to :performed_by, class_name: "Technician"


end
