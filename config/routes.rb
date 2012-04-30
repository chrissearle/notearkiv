Notearkiv::Application.routes.draw do

  scope "/:locale" do
    match 'logout' => 'user_sessions#destroy', :as => :logout
    match 'login' => 'user_sessions#new', :as => :login
    match 'login_once/:code' => 'user_sessions#new_once', :as => :onelogin

    match 'forgotten_password' => 'user_sessions#forgotten', :as => :forgot
    match 'reset_password' => 'user_sessions#reset', :as => :reset

    match 'search' => 'search#search', :as => :search


    resources :user_sessions
    resources :users
    resources :languages
    resources :links
    resources :periods
    resources :composers
    resources :genres
    resources :account
    resources :evensongs
    resources :notes
    resources :dropbox do
      collection do
        get 'authorize'
      end
    end
  end

  match '/:locale' => 'notes#index'
  root :to => 'notes#index'

end
