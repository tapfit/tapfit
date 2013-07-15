require 'resque/server'
require 'api_constraints'

Tapfit::Application.routes.draw do

  # Api Calls
  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :places
    end
  end

  mount Resque::Server.new, :at => "/resque"
end
