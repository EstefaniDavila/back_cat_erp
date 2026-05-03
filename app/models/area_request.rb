class AreaRequest < ApplicationRecord
  include Sanitizable

  belongs_to :quotation
  belongs_to :created_by
  belongs_to :reviewed_by
end
