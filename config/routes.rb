Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resource :found_people

  root "registry#index"
  match "twilio_webhook", to: "registry#twilio_webhook", via: [:post]

end
