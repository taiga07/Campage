class RelationshipsController < ApplicationController

  before_action :authenticate_user!

  def create
    current_user.follow(params[:user_id])
    flash.now[:notice] = 'フォローしました'

    @user = User.find(params[:user_id])
    @following_users = @user.following_user
    @follower_users = @user.follower_user
    @user.create_notification_follow!(current_user)
    render :create  #jsファイルを指定
  end

  def destroy
    current_user.unfollow(params[:user_id])
    flash.now[:alert] = 'フォローを外しました'

    @user = User.find(params[:user_id])
    @following_users = @user.following_user
    @follower_users = @user.follower_user
    render :destroy  #jsファイルを指定
  end

end
