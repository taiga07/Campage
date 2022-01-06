Rails.application.routes.draw do

  devise_for :users
  root 'homes#top'
  get '/about' => 'homes#about'


  resources :users, only: [:show, :edit, :update] do
    # memberを使うことで、7つ以外のルーティングも追加している。
    # 今回の場合、フォロー一覧とフォロワー一覧
    member do
      get :follows, :followers
    end
    resource :relationships, only: [:create, :destroy]
  end

  resource :contacts, only: [:new, :create] do
    member do
      get :confirm
    end
  end

  resources :posts do
    resource :likes, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
  end
  get 'posts/ranking' => 'posts#ranking'
  get 'posts/good_ranking' => 'posts#good_ranking'
  get 'posts/pv_ranking' => 'posts#pv_ranking'

  resource :searches, only: [:index]

  get 'message/:id' => 'messages#show', as: 'message'
  resources :messages, only: [:create]

  resources :notifications, only: [:index]

end
