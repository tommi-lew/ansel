Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  resources :browsers, only: [:index]

  namespace :api do
    resource :browser_stack, controller: :browser_stack, only: [] do
      collection do
        post :job_done
      end
    end
  end
end
