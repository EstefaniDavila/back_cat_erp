class Maintenance < ApplicationRecord
  include Sanitizable

  belongs_to :client
  belongs_to :customer_asset
  belongs_to :enterprise_vehicle
  belongs_to :quotation
  has_many :work_orders, dependent: :destroy
  has_many :maintenance_reports, dependent: :destroy
end
