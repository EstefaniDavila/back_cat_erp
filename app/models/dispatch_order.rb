# app/models/dispatch_order.rb
class DispatchOrder < ApplicationRecord
  include Sanitizable

  belongs_to :sales_order, optional: true
  belongs_to :rental, optional: true
  belongs_to :prepared_by, class_name: 'User'
  has_many :dispatch_items, dependent: :destroy
  has_one :delivery_guide, dependent: :destroy

  validates :code, uniqueness: true, allow_nil: true
  validates :status, presence: true, inclusion: { in: %w[pending dispatched delivered cancelled] }

  before_validation :generate_code, on: :create

  enum status: {
    pending: 'pending',
    dispatched: 'dispatched',
    delivered: 'delivered',
    cancelled: 'cancelled'
  }

  def pending?
    status == 'pending'
  end

  def dispatched?
    status == 'dispatched'
  end

  def delivered?
    status == 'delivered'
  end

  private|

  def generate_code
    return if code.present?
    self.code = "DISP-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.hex(4).upcase}"
  end
end