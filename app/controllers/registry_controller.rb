'require twilio-ruby'

class RegistryController < ApplicationController
  protect_from_forgery prepend: true

  def index
  end

  def twilio_webhook
    message = twilio_client.messages.create(
      body: "Dios te bendiga",
      to: params[:From],
      from: params[:To],
    )
  end

  private

  def twilio_client
    @client ||= Twilio::REST::Client.new(account_sid, auth_token)
  end

  def account_sid
    @account_sid ||= Rails.application.secrets.twilio_account_sid
  end

  def auth_token
    @auth_token ||= Rails.application.secrets.twilio_auth_token
  end
end
