Rails.application.routes.draw do

  devise_for :users
  root 'homes#top'
  get '/about' => 'homes#about'
  get '/search' => 'searches#search'
  get 'posts/good_ranking' => 'posts#good_ranking'
  get 'posts/pv_ranking' => 'posts#pv_ranking'

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
      post :confirm
      post :back
      # getのconfirmとbackに行ったらnewにリダイレクトする記述
      get "confirm" => redirect("contacts/new")
      get "back" => redirect("contacts/new")
    end
  end

  get 'posts/ranking' => 'posts#ranking'

  resources :posts do
    resource :likes, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
  end

  resources :messages, only: [:create]
  resources :rooms, only: [:create, :show, :index]

  resources :notifications, only: [:index]

end
