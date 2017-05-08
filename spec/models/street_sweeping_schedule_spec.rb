require 'rails_helper'

RSpec.describe StreetSweepingSchedule, type: :model do
  date = "2nd and 4th Mon"
  date = "2nd and 4th Tues",
  date = "Every Mon, Wed, Fri"


  describe "sweeping_on?" do
    context "with a sweeping day" do
      subject { StreetSweepingSchedule.new("2nd and 4th Mon") }
      it "is true" do
        expect(subject.sweeping_on?(Date.parse('May 8 2017'))).to be_truthy
      end
    end

    context "with a different day" do
      subject { StreetSweepingSchedule.new("1st and 3rd Thurs") }

      it "is true" do
        expect(subject.sweeping_on?(Date.parse('May 4 2017'))).to be_truthy
      end
    end
  end
end
