class QuotationStatusHistory < ApplicationRecord
  include Sanitizable

  belongs_to :quotation
  belongs_to :changed_by
end
