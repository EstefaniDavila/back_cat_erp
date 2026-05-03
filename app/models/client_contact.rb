class ClientContact < ApplicationRecord
  include Sanitizable

  belongs_to :client
end
