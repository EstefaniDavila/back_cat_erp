class WorkOrder < ApplicationRecord
  include Sanitizable

  belongs_to :maintenance
  belongs_to :assigned_to
  has_many :work_order_actions, dependent: :destroy
  has_many :work_order_parts, dependent: :destroy
end
