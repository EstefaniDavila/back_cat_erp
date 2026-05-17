class MaintenanceReport < ApplicationRecord
  include Sanitizable

  belongs_to :maintenance
  belongs_to :created_by, class_name: 'User'
end
