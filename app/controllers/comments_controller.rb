class CommentsController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    @comment = Comment.new(comment_params)
    # commentsテーブルのuser_idに自分のIDを格納
    @comment.user_id = current_user.id
    # commentsテーブルのpost_idにコメントする投稿のIDを格納
    @comment.post_id = @post.id
    @comment.save
    redirect_to post_path(@post.id)
  end

  def destroy
    # commentをidやpost_idから見つけて削除する。
    Comment.find_by(id: params[:id], post_id: params[:post_id]).destroy
    # 削除後、その投稿の詳細画面に戻る。
    redirect_to post_path(params[:post_id])
  end

  private
  def comment_params
    params.require(:comment).permit(:comment)
  end

end
