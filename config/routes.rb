require 'resque/server'
require 'api_constraints'

Tapfit::Application.routes.draw do

  get "pages/about"
  get "pages/terms"
  get "pages/privacy"
  get "pages/faq"
  devise_for :users
  ActiveAdmin.routes(self)

  root :to => "application#index"

  resources :places do
    resources :photos
  end
  # Api Calls
  namespace :api, defaults: {format: 'json'} do

    devise_for :users
    ActiveAdmin.routes(self)
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :places do
        resources :workouts do
          post 'buy', on: :member
        end
        resources :ratings
        resources :photos
        member do
          post 'favorite'  
          post 'checkin' 
        end    
      end
 
      resources :regions

      def users_resources
        resources :favorites
        resources :checkins
        resources :receipts do
          member do
            post 'use'
          end
        end
        resources :payments do
          collection do
            post 'usecard'
            delete 'delete'
            put 'default'
          end
        end
      end 

      resources :users do
        users_resources
        collection do
          post 'login'
          post 'register'
          post 'logout'
          post 'forgotpassword'
          post 'guest'
        end
      end  


      scope '/:user_id', :constraints => { :user_id => 'me' },
                       :defaults => { :format => 'json' }, :as => 'me' do
        users_resources
      end
      
      get 'me', to: 'users#show' 

    end
  end

  mount Resque::Server.new, :at => "/resque"
end
