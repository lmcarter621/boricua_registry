require 'rails_helper'

describe RegistryController do
  it "should send a message to Twilio" do
    allow(MessageProcessor).to receive(:process_message).with(
      message: "Found Gringo Jane in Cayey born 01-01-1990",
      sender: "+15165510000",
    ).and_return("The reply message")
    
    stub_request(:post, "https://api.twilio.com/2010-04-01/Accounts//Messages.json").
         with(
          body: {"Body"=>"The reply message", "From"=>"+17873392882", "To"=>"+15165510000"},
          headers: {
            'Accept'=>'application/json', 
            'Accept-Charset'=>'utf-8', 
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 
            'Authorization'=>'Basic Og==', 
            'Content-Type'=>'application/x-www-form-urlencoded', 
            'User-Agent'=>'twilio-ruby/5.2.3 (ruby/x86_64-darwin15 2.4.1-p111)'
          }
        ).to_return(status: 200, body: "", headers: {})

    post(
        :twilio_webhook,
        params: {
          "ToCountry"=>"PR", 
          "ToState"=>"Puerto Rico", 
          "SmsMessageSid"=>"FromWayAcrossTheWay94031", 
          "NumMedia"=>"0", 
          "ToCity"=>"GUAYNABO", 
          "FromZip"=>"11751", 
          "SmsSid"=>"SayCheese!", 
          "FromState"=>"NY", 
          "SmsStatus"=>"received", 
          "FromCity"=>"GARDEN CITY", 
          "Body"=>"Found Gringo Jane in Cayey born 01-01-1990", 
          "FromCountry"=>"US", 
          "To"=>"+17873392882", 
          "MessagingServiceSid"=>"IncomingMessagesAreASuccess", 
          "ToZip"=>"00966", 
          "NumSegments"=>"1", 
          "MessageSid"=>"SMcb0140988992eee364777c79499ec74c", 
          "AccountSid"=>"AccountNumber", 
          "From"=>"+15165510000", 
          "ApiVersion"=>"2010-04-01"
        }
    )
  end
end