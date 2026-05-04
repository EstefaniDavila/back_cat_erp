class Product < ApplicationRecord
  
  enum product_type: {
    vehicle: 'vehicle',
    spare_part: 'spare_part'
  }
  
  # Associations
  has_one :vehicle, foreign_key: :product_id, dependent: :destroy, inverse_of: :product
  has_one :spare_part, foreign_key: :product_id, dependent: :destroy, inverse_of: :product

  accepts_nested_attributes_for :vehicle, allow_destroy: true
  accepts_nested_attributes_for :spare_part, allow_destroy: true
  
  belongs_to :created_by, class_name: 'User'
  belongs_to :updated_by, class_name: 'User', optional: true
  
  has_many :product_images, dependent: :destroy
  has_many :quotation_items, dependent: :restrict_with_error
  has_many :work_order_parts, dependent: :restrict_with_error
  has_many :dispatch_items, dependent: :restrict_with_error
  has_many :supplier_products, dependent: :destroy
  has_many :suppliers, through: :supplier_products
  has_many :purchase_order_items, dependent: :restrict_with_error
  
  # Validations
  validates :product_type, presence: true, inclusion: { in: product_types.keys }
  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
  validates :base_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :active, inclusion: { in: [true, false] }
  
  #validate :validate_type_specific_attributes
  
  # Callbacks
  after_validation :normalize_code
  after_update :sync_type_specific_status

  # Scopes
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :vehicles, -> { where(product_type: 'vehicle') }
  scope :spare_parts, -> { where(product_type: 'spare_part') }
  scope :by_code, ->(code) { where('code LIKE ?', "%#{code}%") }
  scope :by_name, ->(name) { where('name LIKE ?', "%#{name}%") }
  
  # Instance Methods
  
  def vehicle?
    product_type == 'vehicle'
  end
  
  def spare_part?
    product_type == 'spare_part'
  end
  
  def specific
    vehicle? ? vehicle : spare_part
  end
  
  def activate!
    update!(active: true)
  end
  
  def deactivate!
    update!(active: false)
  end
  
  def toggle_active!
    update!(active: !active)
  end
  
  def available?(quantity = 1)
    return true if vehicle? && vehicle&.available?
    return spare_part&.stock_available?(quantity) if spare_part?
    false
  end
  
  private
  
  def normalize_code
    self.code = code.upcase.strip if code.present?
  end

    def create_type_specific_record
  if vehicle? && vehicle.nil?
    build_vehicle.save!
  elsif spare_part? && spare_part.nil?
    build_spare_part.save!
  end
end
  
  def validate_type_specific_attributes
    if vehicle?
      errors.add(:base, "Vehicle must have associated vehicle record") unless vehicle.present? || new_record?
    elsif spare_part?
      errors.add(:base, "Spare part must have associated spare_part record") unless spare_part.present? || new_record?
    end
  end
  
  
  def sync_type_specific_status
    if saved_change_to_active? && specific.present?
      specific.update_column(:status, active ? 'active' : 'inactive')
    end
  end
end