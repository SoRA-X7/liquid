require 'rails_helper'

RSpec.describe "rooms/edit", type: :view do
  let(:room) {
    Room.create!(
      name: "MyString",
      description: "MyText",
      available: false
    )
  }

  before(:each) do
    assign(:room, room)
  end

  it "renders the edit room form" do
    render

    assert_select "form[action=?][method=?]", room_path(room), "post" do

      assert_select "input[name=?]", "room[name]"

      assert_select "textarea[name=?]", "room[description]"

      assert_select "input[name=?]", "room[available]"
    end
  end
end
