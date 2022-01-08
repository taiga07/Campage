class PostsController < ApplicationController

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    # postsテーブルの会員IDにログインユーザーのIDを付与する
    if @post.save
      redirect_to posts_path
    else
      render 'new'
    end
  end

  def index
    @post = current_user
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
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


  private

  def post_params
    params.require(:post).permit(:title, :body, post_images_images: [])
    # 複数の画像IDになる為、配列[]で渡している。
  end

end
