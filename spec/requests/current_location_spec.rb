require 'rails_helper'

RSpec.describe "Current Location", type: :request do
  describe "POST /current_locations" do
    context "in a street sweeping zone on a street sweeping day" do
      it "doesn't explore" do
        VCR.use_cassette("full") do
          post current_location_path, params: {
            data: {
              type: :location,
              attributes: {
                latitude: 37.811714,
                longitude: -122.25817699999999,
                date: Date.parse('May 8 2017').to_s
              }
            }
          }
        end

        expect(response).to have_http_status(204)
      end
    end
  end
end
