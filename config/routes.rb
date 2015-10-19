Rudolph::Application.routes.draw do
  devise_for :people, controllers: { invitations: 'invitations',
                                     omniauth_callbacks: "omniauth_callbacks"}

  root 'index#index'

  resources :groups do
    member do
      post   'send-invitations',     as: 'send_invitations'
      delete 'remove_member',        as: 'remove_member'
      put    'make_admin',           as: 'make_admin'
      post   'draw',                 as: 'draw'
      get    'who',                  as: 'who'
      get    'accept_group',         as: 'accept_group'
      delete 'leave_group',          as: 'leave'
      get    'edit_wishlist',        as: 'edit_wishlist'
      post   'update_wishlist',      as: 'update_wishlist'
      delete 'remove_from_wishlist', as: 'remove_from_wishlist'
      get    'message_board',        as: 'message_board'
      post   'send_message',         as: 'send_message'
      get    'wishlists/:person_id', to: 'groups#wishlists', as: 'view_wishlist'

      constraints format: :json do
        get 'get_coordinates',  as: 'get_coordinates'
      end
    end
  end

  resources :people do
    collection do
      post 'change_locale', as: 'change_locale'
    end
  end

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'logout',                  to: 'sessions#destroy'

  get "/404" => "errors#not_found"
  get "/500" => "errors#internal_server_error"

  constraints format: :json do
    get 'get_locale', to: 'application#get_locale', as: 'get_locale'
  end

end
