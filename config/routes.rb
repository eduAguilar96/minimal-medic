Rails.application.routes.draw do
  get 'area/index'
  get 'area/show'
  get 'area/create'
  get 'area/update'
  get 'area/destroy'
  root :to => 'home#index'
  resources :patient, only: [:index, :show, :create, :update, :destroy]
  resources :doctor, only: [:index, :show, :create, :update, :destroy]
  resources :area, only: [:index, :show, :create, :update, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
