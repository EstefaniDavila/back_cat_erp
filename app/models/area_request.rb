class AreaRequest < ApplicationRecord
  include Sanitizable

  belongs_to :quotation
  belongs_to :created_by, class_name: 'User', optional: true
  belongs_to :reviewed_by, class_name: 'User', optional: true

  def self.ransackable_attributes(auth_object = nil)
    ["area", "name", "status", "description"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["quotation", "created_by", "reviewed_by"]
  end
end
