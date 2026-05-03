class UserTrack < ApplicationRecord
  include Sanitizable

  belongs_to :user
end
