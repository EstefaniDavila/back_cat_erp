# app/models/purchase_order.rb
class PurchaseOrder < ApplicationRecord
  include Sanitizable

  belongs_to :supplier
  belongs_to :requested_by, class_name: 'User'
  has_many :purchase_order_items, dependent: :destroy

  accepts_nested_attributes_for :purchase_order_items, allow_destroy: true, reject_if: :all_blank

  validates :code, uniqueness: true, allow_nil: true
  validates :supplier_id, :requested_by_id, presence: true
  validates :status, presence: true, inclusion: { in: %w[draft sent partially_received completed cancelled] }

  before_validation :generate_code, on: :create
  after_save :recalculate_total  

  enum status: {
    draft: 'draft',
    sent: 'sent',
    partially_received: 'partially_received',
    completed: 'completed',
    cancelled: 'cancelled'
  }

  def draft?
    status == 'draft'
  end

  def receive!
    update!(status: 'completed', received_at: Time.current)
  end

  private

  def generate_code
    return if code.present?
    self.code = "PO-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.hex(4).upcase}"
  end

  def recalculate_total 
    update_column(:total, purchase_order_items.sum(:total_cost))
  end
end