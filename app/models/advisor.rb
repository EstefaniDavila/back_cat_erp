class Advisor < ApplicationRecord
  include Sanitizable

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
  has_many :client_advisors, dependent: :destroy
  has_many :leads, foreign_key: :assigned_to_id
  has_many :quotations
  has_many :sales_orders
end