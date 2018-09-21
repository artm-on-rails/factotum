Rails.application.routes.draw do
  devise_for :jacks
  authenticate :jack do
    root to: "application#welcome"
    resources :jacks
    resources :trades
  end
end
