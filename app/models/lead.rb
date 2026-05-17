class Lead < ApplicationRecord
  include CodeGenerator
  include Sanitizable

  belongs_to :assigned_to, class_name: 'Advisor', optional: true
  belongs_to :client, optional: true
  has_many :lead_comments, dependent: :destroy
  has_many :lead_status_histories, dependent: :destroy
  has_many :quotations

  enum priority: {
    NC:  'new_client',
    CP:   'potential',
    NN: 'undesirable',
    NH:  'historical'
  }

  def self.ransackable_attributes(auth_object = nil)
    ["code", "name", "email", "phone", "source", "type", "status", "priority"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["assigned_to", "client"]
  end
end
