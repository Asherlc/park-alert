require 'rails_helper'

RSpec.describe Location, type: :model do
  describe "is_in_streetsweeping_zone?" do
    context "where there's no streetsweeping" do
      subject do
        VCR.use_cassette("in_streetsweeping_zone") do
          Location.new(latitude: 37.795976, longitude: -122.170223).in_streetsweeping_zone_on?(Date.today)
        end
      end

      it { should be_falsey }
    end
  end
end
