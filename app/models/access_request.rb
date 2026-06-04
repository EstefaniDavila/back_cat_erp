class AccessRequest < ApplicationRecord
  belongs_to :created_by, class_name: 'User', optional: true

  def self.ransackable_attributes(auth_object = nil)
    ["status", "requested_role", "first_name", "last_name", "document_number", "email", "created_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["created_by"]
  end
end
