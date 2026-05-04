class Maintenance < ApplicationRecord
  include Sanitizable

  belongs_to :client
  belongs_to :customer_asset, optional: true
  belongs_to :vehicle, optional: true
  belongs_to :quotation, optional: true
  has_many :work_orders, dependent: :destroy
  has_many :maintenance_reports, dependent: :destroy

  before_create :generate_code

  private

  def generate_code
    last = Maintenance.order(:created_at).last
    next_number = last ? last.code.split('-').last.to_i + 1 : 1

    self.code = "MN-#{next_number.to_s.rjust(5, '0')}"
  end

end
