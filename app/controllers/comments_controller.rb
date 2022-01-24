class CommentsController < ApplicationController

  before_action :authenticate_user! #ログインしていないユーザーのURL直打ち対策
  before_action :set_campage, only: [:destroy] #ログインしているユーザーのURL直打ち対策
  before_action :prevent_url, only: [:destroy] #ログインしているユーザーのURL直打ち対策

  def create
    @post = Post.find(params[:post_id])
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @comment.post_id = @post.id
    
    if @comment.save
      @comment.post.create_notification_comment!(current_user, @comment.id)
      flash.now[:notice] = 'コメントを投稿しました'
      render :comments
    else
      render :error
    end
    
  end

  def destroy
    Comment.find_by(id: params[:id], post_id: params[:post_id]).destroy
    flash.now[:alert] = 'コメントを削除しました'
    @post = Post.find(params[:post_id])
    render :comments
  end


  private
  def comment_params
    params.require(:comment).permit(:comment)
  end

  def set_campage
    @comment = Comment.find(params[:id])
  end

  def prevent_url
    if @comment.user_id != current_user.id
      redirect_to root_path
    end
  end

end