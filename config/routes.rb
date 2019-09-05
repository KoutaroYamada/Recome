Rails.application.routes.draw do

  get 'articles/new'
  get 'articles/edit'
  get 'articles/show'
  get 'articles/update'
  get 'articles/destroy'
  root "home#top"
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :articles

end
