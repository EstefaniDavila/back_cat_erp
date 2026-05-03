class RefreshToken < ApplicationRecord
  include Sanitizable

  belongs_to :user
end
