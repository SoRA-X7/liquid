class Room < ApplicationRecord
  has_many :user_room_authorities, dependent: :destroy
  has_many :users, through: :user_room_authorities
  has_many :tickets, dependent: :destroy

  def moderator?(user, level = 1)
    user_room_authorities.where('role >= ?', level).pluck(:user_id).include? user.id
  end

  def owner
    user_room_authorities.find_by(role: 'owner')&.user
  end
end
