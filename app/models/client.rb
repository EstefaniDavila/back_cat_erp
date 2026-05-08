class Client < ApplicationRecord
  include CodeGenerator
  include Sanitizable
  has_paper_trail
  
  has_one :user, as: :roleable, dependent: :destroy
  has_many :client_contacts, dependent: :destroy
  has_many :client_advisors, dependent: :destroy
  has_many :customer_assets, dependent: :destroy
  has_many :leads
  has_many :quotations
  has_many :sales_orders
  has_many :rentals
  has_many :maintenances



  def self.ransackable_attributes(auth_object = nil)
    ["code", "business_name", "document_type", "document_number", "contact_name", "email", "status"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["client_advisors", "leads"]
  end
end
