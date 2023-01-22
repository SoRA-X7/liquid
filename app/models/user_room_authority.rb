class UserRoomAuthority < ApplicationRecord
  belongs_to :user
  belongs_to :room
  enum :role, { nope: 0, mod: 1, admin: 2, owner: 3 }
end
