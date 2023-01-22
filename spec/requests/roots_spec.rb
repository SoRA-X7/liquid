require 'rails_helper'

RSpec.describe "Roots", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/roots/show"
      expect(response).to have_http_status(:success)
    end
  end

end
