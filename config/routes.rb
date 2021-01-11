Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "home#index"

  resources :projects do
    resources :task_lists do
      resources :tasks
    end
  end

  get '/integration/:service', to: 'integration#new', as: 'integration_service'
  post '/integration', to: 'integration#create', as: 'integration_service_create'

end
