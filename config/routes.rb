Notearkiv::Application.routes.draw do

  scope "/:locale" do
    match 'logout' => 'user_sessions#destroy', :as => :logout
    match 'login' => 'user_sessions#new', :as => :login
    match 'login_once/:code' => 'user_sessions#new_once', :as => :onelogin

    match 'forgotten_password' => 'user_sessions#forgotten', :as => :forgot
    match 'reset_password' => 'user_sessions#reset', :as => :reset

    resources :user_sessions
    resources :users
    resources :languages
    resources :links
    resources :periods
    resources :composers
    resources :genres
  end

  #TODO - reset when page available
  match '/:locale' => 'composers#index'
  root :to => 'composers#index'

end
