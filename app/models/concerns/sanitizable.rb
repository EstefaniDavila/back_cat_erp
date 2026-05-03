module Sanitizable
  extend ActiveSupport::Concern

  included do
    before_save :sanitize_data
  end

  private

  def sanitize_data
    self.name = self.name.strip.upcase if self.respond_to?(:name) && self.name.present?
    self.code = self.code.strip.upcase if self.respond_to?(:code) && self.code.present?
    
    # Adicionales útiles si existen en el modelo
    self.serial = self.serial.strip.upcase if self.respond_to?(:serial) && self.serial.present?
    self.serial_number = self.serial_number.strip.upcase if self.respond_to?(:serial_number) && self.serial_number.present?
  end
end
