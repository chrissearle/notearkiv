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

    resources :dropbox do
      collection do
        get 'authorize'
      end
    end

    match 'search' => 'search#search', :as => :search, via: [:get, :post]

    match 'typeahead' => 'search#typeahead', :as => :searchahead, via: [:get]

    devise_for :users

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
  end

  get '/:locale' => 'notes#index'
  root :to => 'notes#index'

end
