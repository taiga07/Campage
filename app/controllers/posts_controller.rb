class PostsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show, :ranking, :pv_ranking, :good_ranking]
  before_action :set_campage, only: [:edit, :update, :destroy]
  before_action :prevent_url, only: [:edit, :update, :destroy]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to posts_path
    else
      render :error
    end
  end

  def index
    @user = current_user
    @posts = Post.all.order(created_at: :desc)  #投稿が新しい順に取得
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @user = @post.user  #投稿に紐付いたユーザー情報を格納
    @following_users = @user.following_user  #そのユーザーがフォローした相手を格納
    @follower_users = @user.follower_user  #そのユーザーがフォローされている相手を格納

    # DM機能
    if user_signed_in?
      @self_room = Entry.where(user_id: current_user.id).pluck(:room_id)  #ログインユーザーが持っているroom_idを取得
      @target_room = Entry.where(user_id: @user.id).pluck(:room_id)
      @roomid = @self_room & @target_room
      if @roomid.blank?  #値がなければtrueを返し処理をする
        @room = Room.new
        @entry = Entry.new
      else
        @isroom = true
      end
    end
    # ここまで
    impressionist(@post, nil, unique: [:ip_address])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post.id)
    else
      render "edit"
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash.now[:alert] = '投稿を削除しました'
    redirect_to user_path(current_user.id)
  end

  def ranking
    #投稿一覧をPV数の多い順に取得。limit(4)で上位4つを取得している。
    @posts_pv_ranking = Post.where(created_at: Time.current.all_month).order(impressions_count: 'DESC').limit(4)  #DESCで降順にしている。
    #post_idが同じレコードをまとめて、post_idが同じものを数え降順に並べる。
    #（いいねテーブルに保存されているレコードを数えることでいいね数を数えることができる。）
    #上位4つを取り出し、レコードの情報をidに変更する。
    @posts_good_ranking = Post.where(created_at: Time.current.all_month).where(id: Like.group(:post_id).order('count(post_id) DESC').pluck(:post_id)).limit(4)
    @date1 = Date.current.strftime('%m')
  end

  def pv_ranking
    @posts_pv_ranking = Post.where(created_at: Time.current.all_month).order(impressions_count: 'DESC').page(params[:page]).per(8)
    @date1 = Date.current.strftime('%m')
  end

  def good_ranking
    @posts_good_ranking = Post.where(created_at: Time.current.all_month).where(id: Like.group(:post_id).order('count(post_id) DESC').pluck(:post_id))
    @posts_good_ranking = Kaminari.paginate_array(@posts_good_ranking).page(params[:page]).per(8)
    @date1 = Date.current.strftime('%m')
  end



  private

  def post_params
    params.require(:post).permit(:title, :body, post_images_images: [])
    # 複数の画像IDになる為、配列[]で渡している。
  end

  def set_campage
    @post = Post.find(params[:id])
  end

  def prevent_url
    if @post.user_id != current_user.id
      redirect_to root_path
    end
  end
end
