Rails.application.routes.draw do

  root "home#top"
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :articles do
    collection do
      get 'get_url'
      post 'input_tag'
    end
  end

end
