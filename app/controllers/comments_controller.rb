class CommentsController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    @comment = Comment.new(comment_params)
    # commentsテーブルのuser_idに自分のIDを格納
    @comment.user_id = current_user.id
    # commentsテーブルのpost_idにコメントする投稿のIDを格納
    @comment.post_id = @post.id
    if @comment.save
      @comment.create_notification_comment!(current_user, @comment.id)
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

end
