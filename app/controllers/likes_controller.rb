class LikesController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    @like = Like.new(post_id: @post.id)
    @like.user_id = current_user.id
    @like.save
    redirect_to post_path(@post.id)
  end

  def destroy
    @post = Post.find(params[:post_id])
    @like = current_user.likes.find_by(post_id: @post.id)
    @like.destroy
    redirect_to post_path(@post.id)
  end

end
