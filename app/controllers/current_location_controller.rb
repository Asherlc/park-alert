class CurrentLocationController < ApplicationController
  def create
    location = Location.create(params[:data][:attributes][:x], params[:data][:attributes][:y])

    if location.is_in_streetsweeping_zone?
      twilio = Twilio::REST::Client.new Rails.application.secrets.twilio.sid, Rails.application.secrets.twilio.token]

      message = twilio.account.messages.create(
        from: Rails.application.secrets.phone_number,
        :to => Rails.application.secrets.phone_number,
        :body => "You're parked in a street sweeping zone!",
      )
    end
  end
end
