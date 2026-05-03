class LeadComment < ApplicationRecord
  include Sanitizable

  belongs_to :lead
  belongs_to :user
end
