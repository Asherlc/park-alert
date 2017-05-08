require 'rails_helper'

RSpec.describe "Current Location", type: :request do
  describe "POST /current_locations" do
    context "in a street sweeping zone" do
      it "sends me an SMS" do
        post current_locations_path, data: {
          type: :location,
          attributes: {
            x: 6053969.411907528, y: 2122698.4910406736
          }
        }

        expect(response).to have_http_status(200)
      end
    end
  end
end
