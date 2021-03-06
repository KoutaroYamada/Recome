Rails.application.routes.draw do

  root "home#top"

  scope :home do
    get "/:tag_name" => "home#top", as: :home_tag_ranking
  end

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

  resources :users do
    member do
      get :following, :followers, :favorites,:my_collection
      patch :add_favorite_tag
      patch :remove_favorite_tag
    end

    collection do
      get :tag_search
    end
    
    resource :relationships, only:[:create, :destroy]
    
  end



end
