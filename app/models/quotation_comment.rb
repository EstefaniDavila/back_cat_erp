class QuotationComment < ApplicationRecord
  include Sanitizable

  belongs_to :quotation
  belongs_to :user
end
