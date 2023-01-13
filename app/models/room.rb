class Room < ApplicationRecord
  has_many :user_room_authorities, dependent: :destroy
  has_many :users, through: :user_room_authorities
end
