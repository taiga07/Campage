class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])  #ユーザーの情報を取得
    @posts = @user.posts  #そのユーザーに紐づいた投稿を@postsに格納
    @following_users = @user.following_user  #そのユーザーがフォローした相手を格納
    @follower_users = @user.follower_user  #そのユーザーがフォローされている相手を格納
    #entriesテーブルにログインユーザーとDMボタンを押されたユーザーを、
    #記憶する必要があるので、whereメソッドで探し格納している。
    @currentuserentry=Entry.where(user_id: current_user.id)  #自分が参加しているメッセージルーム情報を取得する
    @userentry=Entry.where(user_id: @user.id)  #選択したユーザのメッセージルーム情報を取得する
    unless @user.id == current_user.id  #自分自身とはDMができないため
      @currentuserentry.each do |cu|  #current_userが参加していルームをひとつずつ取り出す
        @userentry.each do |u|  #@user（選択したユーザー）が参加しているルームをひとつずつ取り出す
          if cu.room_id == u.room_id  #current_userと@userのルームが同じか判断（既にルームが存在するかどうか）
            @isroom = true  #falseの時(同じじゃない時)の条件を記述するために変数に代入
            @roomid = cu.room_id  #ルームが共通しているcurrent_userと@userに対して変数を指定
          end
        end
      end
      unless @isroom  #unlessで@isroomがfalseの時という意味（roomが存在しない時）
        @room = Room.new  #新しいインスタンスを生成
        @entry = Entry.new  #新しいインスタンスを生成
      end
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
