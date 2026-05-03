class Client < ApplicationRecord
  include CodeGenerator
  include Sanitizable

  has_many :client_contacts, dependent: :destroy
  has_many :client_advisors, dependent: :destroy
  has_many :customer_assets, dependent: :destroy
  has_many :leads
  has_many :quotations
  has_many :sales_orders
  has_many :rentals
  has_many :maintenances
end
