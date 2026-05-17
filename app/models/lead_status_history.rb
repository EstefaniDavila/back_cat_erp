class LeadStatusHistory < ApplicationRecord
  include Sanitizable

  belongs_to :lead
  belongs_to :changed_by, class_name: 'User'
end
