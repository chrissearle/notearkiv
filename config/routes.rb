Notearkiv::Application.routes.draw do

  scope "/:locale" do
    match 'logout' => 'user_sessions#destroy', :as => :logout
    match 'login' => 'user_sessions#new', :as => :login
    match 'login_once/:code' => 'user_sessions#new_once', :as => :onelogin

    match 'forgotten_password' => 'user_sessions#forgotten', :as => :forgot
    match 'reset_password' => 'user_sessions#reset', :as => :reset

    match 'search' => 'search#search', :as => :search

    match 'typeahead' => 'search#typeahead', :as => :searchahead

    resources :user_sessions
    resources :users
    resources :languages
    resources :links
    resources :periods
    resources :composers
    resources :genres
    resources :account
    resources :evensongs do
      collection do
        post 'sorted'
      end
    end
    resources :notes do
      collection do
        post 'sorted'
      end
    end
    resources :messages
    resources :uploads do
      collection do
        get 'link'
      end
      member do
        get 'refresh'
      end
    end
    resources :dropbox do
      collection do
        get 'authorize'
      end
    end
  end

  match '/:locale' => 'notes#index'
  root :to => 'notes#index'

end
