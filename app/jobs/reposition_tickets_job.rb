class RepositionTicketsJob < ApplicationJob
  queue_as :default

  def perform(room)
    room.tickets.alive.find_each.with_index do |t, i|
      t.update!(position: i + 1)
    end
  end
end
