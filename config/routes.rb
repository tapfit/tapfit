require 'resque/server'
require 'api_constraints'

Tapfit::Application.routes.draw do

  resources :contests do
    resources :contestants, :except => [:index, :update, :edit, :destroy]
  end

  match 'about'     => 'pages#about', :via => :get
  # match 'plans'     => 'pages#plans', :via => :get
  match 'corporate' => 'pages#corporate', :via => :get
  match 'promotion' => 'pages#promotion', :via => :get
  match 'sale'      => 'pages#sale', :via => :get
  match 'credits'   => 'pages#credits', :via => :get
  match 'locations' => 'pages#locations', :via => :get
  match 'terms'     => 'pages#terms', :via => :get
  match 'privacy'   => 'pages#privacy', :via => :get
  match 'faq'       => 'pages#faq', :via => :get
  match 'android'   => 'pages#android', :via => :get
  match 'iphone'    => 'pages#iphone', :via => :get
  match 'iPhone'    => 'pages#iphone', :via => :get
  match 'dummy'     => 'pages#dummy', :via => :get
 
  devise_for :users

  ActiveAdmin.routes(self)

  resources :places do
    resources :photos
  end

  resources :packages do
    collection do
      post 'buy'
      get 'confirmation'
      get 'oops'
    end
  end

  resources :trackings

  resources :email_collections

  # Api Calls
  
    def core_resources
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
        collection do
          get 'search'
        end
      end

      resources :packages do
        post 'buy', on: :collection
      end

      resources :regions

      resources :trackings

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
        resources :promo_codes, only: [ :create ]
      end 

      resources :users do
        users_resources
        collection do
          post 'login'
          post 'register'
          post 'logout'
          post 'forgotpassword'
          post 'guest'
          post 'shared'
        end
      end  


      scope '/:user_id', :constraints => { :user_id => 'me' },
                       :defaults => { :format => 'json' }, :as => 'me' do
        users_resources
      end
      
      get 'me', to: 'users#show' 
  end


  namespace :api, defaults: {format: 'json'} do

    devise_for :users
    ActiveAdmin.routes(self)
    scope module: :v2, constraints: ApiConstraints.new(version: 2, default: false) do
      core_resources
    end
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      core_resources
    end
  end

  
  mount Resque::Server.new, :at => "/resque"
  
  root :to => "pages#index"
  match '*path' => "pages#index", :via => :get

end
