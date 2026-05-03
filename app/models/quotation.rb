class Quotation < ApplicationRecord
  include Sanitizable

  belongs_to :client
  belongs_to :advisor
  belongs_to :lead
  has_many :quotation_items, dependent: :destroy
  has_many :quotation_comments, dependent: :destroy
  has_many :quotation_status_histories, dependent: :destroy
  has_many :quotation_files, dependent: :destroy
  has_one :sales_order, dependent: :destroy
  has_one :rental, dependent: :destroy
  has_one :maintenance, dependent: :destroy
  has_many :area_requests, dependent: :destroy
end
