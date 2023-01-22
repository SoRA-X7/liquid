class Ticket < ApplicationRecord
  belongs_to :room
  belongs_to :user

  scope :current, -> { where(position: 0) }
  scope :alive, -> { where('position > 0') }
end
