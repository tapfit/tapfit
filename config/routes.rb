require 'resque/server'
require 'api_constraints'

Tapfit::Application.routes.draw do

  devise_for :users
  # Api Calls
  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :places

      resources :users do
        collection do
          post 'login'
          post 'register'
          post 'logout'
          post 'forgotpassword'
        end
      end
    end
  end

  mount Resque::Server.new, :at => "/resque"
end
