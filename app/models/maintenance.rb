class Maintenance < ApplicationRecord
  include Sanitizable

  belongs_to :client
  belongs_to :customer_asset
  belongs_to :enterprise_vehicle
  belongs_to :quotation
  has_one :work_order, dependent: :destroy
  has_many :maintenance_reports, dependent: :destroy
end
