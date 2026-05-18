class Rental < ApplicationRecord
  include Sanitizable

  belongs_to :quotation
  belongs_to :client
  belongs_to :vehicle, optional: true  # Se asigna luego en Logística
  has_many :dispatch_orders

  before_create :generate_code

  private

  def generate_code
    last = Rental.order(:created_at).last
    next_number = last ? last.code.split('-').last.to_i + 1 : 1

    self.code = "RL-#{next_number.to_s.rjust(7, '0')}"
  end

end
