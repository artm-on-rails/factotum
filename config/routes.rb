Rails.application.routes.draw do
  devise_for :jacks
  authenticate :jack do
    root to: "application#welcome"
    resources :jacks, except: %i[show]
    resources :trades
    resource :profile, only: %i[show edit update]
  end
end
