class QuotationStatusHistory < ApplicationRecord
  include Sanitizable

  belongs_to :quotation
  belongs_to :changed_by, class_name: 'User'
end
