Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users, controllers: { registrations: "registrations" }, as: 'original_devise'
  scope module: 'api' do
    namespace :v1, defaults: { format: :json, path: '/' } do


      resources :users, only: [:index, :create, :destroy, :update, :show] do
        collection do
          post 'reset_password'
          get 'confirm_token'
          get 'get_role'
        end
      end   

      resources :donation_events, only: [:index, :create, :destroy] do
        collection do
          get 'index_owner'
          get 'change_status'
        end
      end   
    end
  end
end
