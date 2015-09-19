Rudolph::Application.routes.draw do
  devise_for :people, controllers: { invitations: 'invitations',
                                     omniauth_callbacks: "omniauth_callbacks"}

  root 'index#index'

  resources :groups do
    member do
      post   'send-invitations', as: 'send_invitations'
      delete 'remove_member',    as: 'remove_member'
      put    'make_admin',       as: 'make_admin'
      post   'draw',             as: 'draw'
      get    'who',              as: 'who'
      get    'accept_group',     as: 'accept_group'
      delete 'leave_group',      as: 'leave'
      get    'edit_wishlist',    as: 'edit_wishlist'
      post   'update_wishlist',  as: 'update_wishlist'

      constraints format: :json do
        get 'get_coordinates',  as: 'get_coordinates'
      end
    end
  end

  resources :people

  get    'auth/:provider/callback', to: 'sessions#create'
  get    'logout',                  to: 'sessions#destroy'

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
