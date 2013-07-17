require 'resque/server'
require 'api_constraints'

Tapfit::Application.routes.draw do

  devise_for :users
  # Api Calls
  namespace :api, defaults: {format: 'json'} do

    devise_for :users
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :places do
        resources :workouts
        member do
          post 'favorite'   
        end    
      end
 
      def users_resources
        resources :favorites
      end 

      resources :users do
        users_resources
        collection do
          post 'login'
          post 'register'
          post 'logout'
          post 'forgotpassword'
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
