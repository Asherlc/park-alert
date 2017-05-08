class CurrentLocationController < ApplicationController
  def create
    location = Location.new(latitude: params[:data][:attributes][:latitude], longitude: params[:data][:attributes][:longitude])
    date = Date.parse(params[:data][:attributes][:date])
    
    if location.in_streetsweeping_zone_on?(date)
      twilio = Twilio::REST::Client.new(Rails.application.secrets.twilio[:sid], Rails.application.secrets.twilio[:token])

      message = twilio.account.messages.create(
        from: Rails.application.secrets.twilio[:number],
        :to => Rails.application.secrets.phone_number,
        :body => "You're parked in a street sweeping zone!"
      )
    end
  end
end
