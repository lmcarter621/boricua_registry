require 'rails_helper'

describe RegistryController do
  
  context "valid messages" do
    it "should reply with success" do
      stub_request(:post, "https://api.twilio.com/2010-04-01/Accounts/AC731bd8f891a141aab0be8af5f2c50f78/Messages.json").
         with(body: {"Body"=>"Dios te bendiga", "From"=>"+17873392882", "To"=>"+15165510000"},
              headers: {'Accept'=>'application/json', 'Accept-Charset'=>'utf-8', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Basic QUM3MzFiZDhmODkxYTE0MWFhYjBiZThhZjVmMmM1MGY3ODo3NDUxOWEwNjA2Yjk2OTEyM2RkZjVmOTVkYTc4MzY4Ng==', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'twilio-ruby/5.2.3 (ruby/x86_64-darwin15 2.4.1-p111)'}).
         to_return(status: 200, body: "", headers: {})

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
  
  context "invalid messages" do
    it "should reply with an expected format" do
      stub_request(:post, "https://api.twilio.com/2010-04-01/Accounts/AC731bd8f891a141aab0be8af5f2c50f78/Messages.json").
         with(body: {"Body"=>"Sorry.\n Try entering 'Found [first name] [last name] in [town] born [birthdate]", "From"=>"+17873392882", "To"=>"+15165510000"},
              headers: {'Accept'=>'application/json', 'Accept-Charset'=>'utf-8', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Basic QUM3MzFiZDhmODkxYTE0MWFhYjBiZThhZjVmMmM1MGY3ODo3NDUxOWEwNjA2Yjk2OTEyM2RkZjVmOTVkYTc4MzY4Ng==', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'twilio-ruby/5.2.3 (ruby/x86_64-darwin15 2.4.1-p111)'}).
         to_return(status: 200, body: "", headers: {})
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
end