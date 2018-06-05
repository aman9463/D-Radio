Rails.application.routes.draw do
	root 'rooms#index'
  resources :rooms
 scope module: :users do
        devise_for :users, skip: [:passwords, :passwords, :registrations]
      end
devise_scope :user do
      get 'auth/login', to: 'users/sessions#custom_login', as: :login
    end
  # devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
