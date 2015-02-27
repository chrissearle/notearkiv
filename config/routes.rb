Rails.application.routes.draw do
  scope "/:locale" do
    resources :genres
    resources :languages
    resources :periods
    resources :composers
    resources :account
    resources :admin_users
    resources :messages
    resources :links, :except => [:show, :index]

    resources :evensongs
#    resources :evensongs do
#      collection do
#        post 'sorted'
#      end
#    end

    resources :notes do
      collection do
        get 'voices'
      end
#      collection do
#        post 'sorted'
#      end
    end

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


    match 'search/:type' => 'search#index', :as => :typedsearch, via: [:get, :post]

    match 'search' => 'search#search', :as => :search, via: [:get, :post]

    match 'typeahead' => 'search#typeahead', :as => :searchahead, via: [:get]

    devise_for :users

  end

  get '/:locale' => 'notes#index'
  root :to => 'notes#index'

end
