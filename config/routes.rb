Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  scope module: 'api' do
    namespace :v1, defaults: { format: :json, path: '/' } do

      resources :users, only: [:index, :create, :destroy, :update] do
        collection do
          post 'get_role'
          post 'reset_password'
          post 'password'
        end
      end   

      resources :donation_events, only: [:index, :create, :destroy, :update] do
        collection do
          get 'index_owner'
          get 'change_status'
        end
      end   

    end
  end
end
