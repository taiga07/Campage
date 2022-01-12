class PostsController < ApplicationController

  # impressionist :actions => [:show]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id  # postsテーブルの会員IDにログインユーザーのIDを付与する
    if @post.save
      redirect_to posts_path
    else
      render 'new'
    end
  end

  def index
    @user = current_user
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @user = @post.user  #投稿に紐付いたユーザー情報を格納
    @following_users = @user.following_user  #そのユーザーがフォローした相手を格納
    @follower_users = @user.follower_user  #そのユーザーがフォローされている相手を格納

    @self_room = Entry.where(user_id: current_user.id).pluck(:room_id)
    @target_room = Entry.where(user_id: @user.id).pluck(:room_id)
    @roomid = @self_room & @target_room
    if @roomid.blank?
      @room = Room.new  #新しいインスタンスを生成
      @entry = Entry.new  #新しいインスタンスを生成
    else
      @isroom = true
    end

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
    redirect_to user_path(current_user.id)
  end



  def ranking
    #投稿一覧をPV数の多い順に取得。limit(5)で上位5つを取得している。
    @posts_pv_ranking = Post.order(impressions_count: 'DESC').limit(5)  #DESCで降順にしている。
    #post_idが同じレコードをまとめて、post_idが同じものを数え降順に並べる。
    #（いいねテーブルに保存されているレコードを数えることでいいね数を数えることができる。）
    #上位5つを取り出し、レコードの情報をidに変更する。
    @posts_like_ranking = Post.find(Like.group(:post_id).order('count(post_id) desc').limit(5).pluck(:post_id))
  end

  def pv_ranking
    @posts_pv_ranking = Post.order(impressions_count: 'DESC')
  end

  def good_ranking
    @posts_like_ranking = Post.find(Like.group(:post_id).order('count(post_id) desc').pluck(:post_id))
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, post_images_images: [])
    # 複数の画像IDになる為、配列[]で渡している。
  end

end
