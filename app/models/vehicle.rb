# app/models/vehicle.rb
class Vehicle < ApplicationRecord
  include Sanitizable

  belongs_to :product, inverse_of: :vehicle
  belongs_to :vehicle_model
  has_many :rentals
  has_many :delivery_guides
  has_many :maintenances, foreign_key: :enterprise_vehicle_id

  STATUSES = {
    available: 'available',   
    disabled: 'disabled',     
    maintenance: 'maintenance',
    sold: 'sold',             
    rented: 'rented',
    logistic: 'logistic'           
  }.freeze

  validates :status, inclusion: { in: STATUSES.values }, allow_nil: true

  scope :available, -> { where(status: STATUSES[:available]) }
  scope :visible, -> { where(status: STATUSES[:available]) }  
  scope :for_sale, -> { where(status: STATUSES[:available]) }
  scope :for_rent, -> { where(status: STATUSES[:available]) }
  scope :commercial, -> { where(status: [STATUSES[:available], STATUSES[:rented]]) }
  scope :delivery_vehicles, -> { where(status: STATUSES[:logistic]) }

  def available?
    status == STATUSES[:available]
  end

  def disabled?
    status == STATUSES[:disabled]
  end

  def maintenance?
    status == STATUSES[:maintenance]
  end

  def sold?
    status == STATUSES[:sold]
  end

  def rented?
    status == STATUSES[:rented]
  end

  def logistic?
    status == STATUSES[:logistic]
  end

  def mark_as_available!
    update(status: STATUSES[:available])
  end

  def mark_as_disabled!
    update(status: STATUSES[:disabled])
  end

  def mark_as_maintenance!
    update(status: STATUSES[:maintenance])
  end

  def mark_as_sold!
    update(status: STATUSES[:sold])
  end

  def mark_as_rented!
    update(status: STATUSES[:rented])
  end

  def mark_as_returned!
    update(status: STATUSES[:available]) if rented?
  end

  def mark_as_logistic!
    update(status: STATUSES[:logistic])
  end

   after_save :sync_product_active_status
   
   def sync_product_active_status
    return unless product.present?
    
    active_status = status.in?(%w[available logistic])
    
    if product.active != active_status
      product.update_column(:active, active_status)
    end
  end

end