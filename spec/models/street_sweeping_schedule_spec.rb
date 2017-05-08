require 'rails_helper'

RSpec.describe StreetSweepingSchedule, type: :model do
  date = "2nd and 4th Mon"
  date = "2nd and 4th Tues",
  date = "Every Mon, Wed, Fri"

  subject { StreetSweepingSchedule.new("2nd and 4th Mon") }

  describe "sweeping_on?" do
    context "with a sweeping day" do
      it "is true" do
        expect(subject.sweeping_on?(Date.parse('May 8 2017'))).to be_truthy
      end
    end
  end
end
