class WorkOrderAction < ApplicationRecord
  include Sanitizable
  has_one_attached :cover, dependent: :purge_later

  belongs_to :work_order
  belongs_to :performed_by, class_name: "Technician"


end
