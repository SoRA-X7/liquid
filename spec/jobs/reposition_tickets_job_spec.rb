require 'rails_helper'

RSpec.describe RepositionTicketsJob, type: :job do
  let(:room) { Room.create! }
  let(:user) { User.create!(email: 'abc@example.com', password: 'abcdef') }
  before do
    10.times do |i|
      room.tickets << Ticket.create(room:, user:, position: i + 1)
    end
  end
  it 'correctly updates all tickets\' positions' do
    room.tickets.first.destroy!
    RepositionTicketsJob.perform_now(room)
    expect(room.tickets.size).to eq 9
    expect(room.tickets[0].position).to eq 1
    expect(room.tickets[8].position).to eq 9
  end
end
