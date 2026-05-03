class ClientAdvisor < ApplicationRecord
  include Sanitizable

  belongs_to :client
  belongs_to :advisor
end
