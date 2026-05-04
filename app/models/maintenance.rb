class Maintenance < ApplicationRecord
  include Sanitizable

  belongs_to :client
  belongs_to :customer_asset
  belongs_to :enterprise_vehicle
  belongs_to :quotation
  has_many :work_order, dependent: :destroy
  has_many :maintenance_reports, dependent: :destroy

  private

  def generate_code
    last = Maintenance.order(:created_at).last
    next_number = last ? last.code.split('-').last.to_i + 1 : 1

    self.code = "MN-#{next_number.to_s.rjust(5, '0')}"
  end

end
