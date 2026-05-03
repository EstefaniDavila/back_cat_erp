# app/models/product.rb
class Product < ApplicationRecord

  # Enums

  enum type: {
    vehicle: 'vehicle',
    spare_part: 'spare_part'
  }
  
  # Associations

  # Relaciones polimórficas inversas
  has_one :vehicle, foreign_key: :product_id, dependent: :destroy
  has_one :spare_part, foreign_key: :product_id, dependent: :destroy
  
  # Relaciones comunes
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

  validates :type, presence: true, inclusion: { in: types.keys }
  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
  validates :base_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :active, inclusion: { in: [true, false] }
  
  validate :validate_type_specific_attributes
  
  # Callbacks

  before_validation :normalize_code
  after_create :create_type_specific_record
  after_update :sync_type_specific_status

  # Scopes

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :vehicles, -> { where(type: 'vehicle') }
  scope :spare_parts, -> { where(type: 'spare_part') }
  scope :by_code, ->(code) { where('code LIKE ?', "%#{code}%") }
  scope :by_name, ->(name) { where('name LIKE ?', "%#{name}%") }
  
  # Instance Methods
  
  # Verifica si el producto es un vehículo
  def vehicle?
    type == 'vehicle'
  end
  
  # Verifica si el producto es un repuesto
  def spare_part?
    type == 'spare_part'
  end
  
  # Obtiene el tipo específico (Vehicle o SparePart)
  def specific
    vehicle? ? vehicle : spare_part
  end
  
  # Activa el producto
  def activate!
    update!(active: true)
  end
  
  # Desactiva el producto
  def deactivate!
    update!(active: false)
  end
  
  # Cambia el estado activo/inactivo
  def toggle_active!
    update!(active: !active)
  end
  
  # Verifica disponibilidad (para repuestos verifica stock)
  def available?(quantity = 1)
    return true if vehicle? && vehicle&.available?
    return spare_part&.stock_available?(quantity) if spare_part?
    false
  end
  
  private
  
  # Normaliza el código a mayúsculas
  def normalize_code
    self.code = code.upcase.strip if code.present?
  end
  
  # Valida atributos específicos según el tipo
  def validate_type_specific_attributes
    if vehicle?
      # Validaciones específicas para vehículos se manejan en el modelo Vehicle
      errors.add(:base, "Vehicle must have associated vehicle record") unless vehicle.present? || new_record?
    elsif spare_part?
      # Validaciones específicas para repuestos se manejan en el modelo SparePart
      errors.add(:base, "Spare part must have associated spare_part record") unless spare_part.present? || new_record?
    end
  end
  
  # Crea el registro específico según el tipo (Vehicle o SparePart)
  def create_type_specific_record
    if vehicle? && !vehicle.present?
      build_vehicle.save!
    elsif spare_part? && !spare_part.present?
      build_spare_part.save!
    end
  end
  
  # Sincroniza el estado active con el registro específico
  def sync_type_specific_status
    if saved_change_to_active? && specific.present?
      specific.update_column(:status, active ? 'active' : 'inactive')
    end
  end
end