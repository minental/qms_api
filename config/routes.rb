Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resource  :user, only: [:show]
      namespace :user do
        resource :sessions, only: [:create, :destroy]
      end
      resources :operators, only: [:create, :show, :index, :update, :destroy]
      resources :customers, only: [:create, :show, :index, :update, :destroy]
      resource :serving, only: [:show] do
        member do
          put :next
          put :close
          put :no_show
        end
      end
      resource :queue, only: [:show]
    end
  end
end
