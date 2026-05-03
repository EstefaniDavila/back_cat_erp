class BlacklistedToken < ApplicationRecord
  include Sanitizable

  belongs_to :user
end
