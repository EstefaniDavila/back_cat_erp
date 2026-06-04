class InformationRequest < ApplicationRecord
  belongs_to :client, optional: true
  belongs_to :advisor, class_name: 'User', optional: true
  has_one_attached :document

  validates :subject, presence: true
  validates :message, presence: true
  
  # Si el usuario no está logueado, debe proporcionar su nombre y teléfono
  validates :name, presence: true, if: -> { client_id.nil? }
  validates :phone, presence: true, if: -> { client_id.nil? }
end
