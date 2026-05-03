class QuotationFile < ApplicationRecord
  include Sanitizable

  belongs_to :quotation
end
