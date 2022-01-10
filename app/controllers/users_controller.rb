class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])  #ユーザーの情報を取得
    @posts = @user.posts  #そのユーザーに紐づいた投稿を@postsに格納
    @following_users = @user.following_user  #そのユーザーがフォローした相手を格納
    @follower_users = @user.follower_user  #そのユーザーがフォローされている相手を格納
    
    @self_room = Entry.where(user_id: current_user.id).pluck(:room_id)
    @target_room = Entry.where(user_id: params[:id]).pluck(:room_id)
    @roomid = @self_room & @target_room
    if @roomid.blank?
      @room = Room.new  #新しいインスタンスを生成
      @entry = Entry.new  #新しいインスタンスを生成
    else
      @isroom = true
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(current_user)
    else
      render :edit
    end
  end

  # フォロー一覧
  def follows
    # 特定のユーザー情報を取得
    @user = User.find(params[:id])
    # そのユーザーにフォローされているユーザーを@usersに格納
    @users = @user.following_user
  end

  # フォロワー一覧
  def followers
    # 特定のユーザー情報を取得
    @user = User.find(params[:id])
    # そのユーザーがフォローされているユーザーを@usersに格納
    @users = @user.follower_user
  end


  private

  def user_params
    params.require(:user).permit(:name, :introduction, :email, :phone_number, :profile_image)
  end

end
