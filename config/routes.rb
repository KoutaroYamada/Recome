Rails.application.routes.draw do

  get 'users/index'
  get 'users/new'
  get 'users/edit'
  get 'users/show'
  root "home#top"
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :articles do
    collection do
      #投稿フォームで入力されたURLを非同期で受け取り
      get 'get_url'
      #タグの登録
      post 'input_tag'
    end
    #いいね
    resource :favorites, only: [:create, :destroy]
  end

  resources :users

end
