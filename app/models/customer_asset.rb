class CustomerAsset < ApplicationRecord
  include Sanitizable

  belongs_to :client
end
