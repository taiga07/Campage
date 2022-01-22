class CommentsController < ApplicationController

  before_action :authenticate_user! #ログインしていないユーザーのURL直打ち対策
  before_action :set_campage, only: [:destroy] #ログインしているユーザーのURL直打ち対策
  before_action :prevent_url, only: [:destroy] #ログインしているユーザーのURL直打ち対策

  def create
    @post = Post.find(params[:post_id])
    @comment = Comment.new(comment_params)
    # commentsテーブルのuser_idに自分のIDを格納
    @comment.user_id = current_user.id
    # commentsテーブルのpost_idにコメントする投稿のIDを格納
    @comment.post_id = @post.id
    if @comment.save
      @comment.post.create_notification_comment!(current_user, @comment.id)
      # 連続で投稿した際にフラッシュメッセージが残らないよう、flash.nowとする
      flash.now[:notice] = 'コメントを投稿しました'
      #render先をcomments.js.erbに指定
      render :comments
    else
      #render先をerror.js.erbに指定
      render :error
    end
  end

  def destroy
    # commentをidやpost_idから見つけて削除する。
    Comment.find_by(id: params[:id], post_id: params[:post_id]).destroy
    # 連続で失敗した際にフラッシュメッセージが残らないよう、flash.nowとする
    flash.now[:alert] = 'コメントを削除しました'
     #render先をcomments.js.erbに指定
     #renderしたときに@postのデータがないので@postを定義
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
