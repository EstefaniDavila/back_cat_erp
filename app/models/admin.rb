class Admin < ApplicationRecord
  after_create :generate_user

  has_one :user, as: :roleable, dependent: :destroy


  def generate_user
    User.create!(
      email: self.email,
      document_number: self.document_number,
      password: self.document_number,
      password_confirmation: self.document_number,
      roleable: self
    )
  end
end