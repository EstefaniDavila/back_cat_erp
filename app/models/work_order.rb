class WorkOrder < ApplicationRecord
  include Sanitizable

  belongs_to :maintenance
  belongs_to :assigned_to, class_name: 'Technician'
  has_many :work_order_actions, dependent: :destroy
  has_many :work_order_parts, dependent: :destroy

  before_create :generate_code

  private

  def generate_code
    last = WorkOrder.order(:created_at).last
    next_number = last ? last.code.split('-').last.to_i + 1 : 1

    self.code = "WO-#{next_number.to_s.rjust(7, '0')}"
  end
  
end
