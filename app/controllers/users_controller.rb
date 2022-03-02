class UsersController < ApplicationController

  before_action :authenticate_user!, only: [:edit, :update]
  before_action :set_campage, only: [:edit, :update]
  before_action :prevent_url, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc)  #新しい順
    @following_users = @user.following_user  #ユーザーがフォローした相手を格納
    @follower_users = @user.follower_user  ##ユーザーがフォローされている相手を格納

    if user_signed_in?
      # DM機能
      @self_room = Entry.where(user_id: current_user.id).pluck(:room_id)
      @target_room = Entry.where(user_id: params[:id]).pluck(:room_id)
      @roomid = @self_room & @target_room
      if @roomid.blank?
        @room = Room.new
        @entry = Entry.new
      else
        @isroom = true
      end
      # ここまで
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
    @user = User.find(params[:id])
    # ユーザーにフォローされているユーザーを取得
    @users = @user.following_user.page(params[:page]).per(10)
  end

  # フォロワー一覧
  def followers
    @user = User.find(params[:id])
    # ユーザーがフォローされているユーザーを取得
    @users = @user.follower_user.page(params[:page]).per(10)
  end


  private
  def user_params
    params.require(:user).permit(:name, :introduction, :email, :phone_number, :profile_image)
  end

  def set_campage
    @user = User.find(params[:id])
  end

  def prevent_url
    if @user.id != current_user.id
      redirect_to root_path
    end
  end

end
