class Lead < ApplicationRecord
  include CodeGenerator
  include Sanitizable

  belongs_to :assigned_to
  belongs_to :client
  has_many :lead_comments, dependent: :destroy
  has_many :lead_status_histories, dependent: :destroy
  has_many :quotations
end
