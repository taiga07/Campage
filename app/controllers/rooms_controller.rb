class RoomsController < ApplicationController

  def create
    @room = Room.create  #ルームを作成
    #Entriesテーブルのuser_idカラムには自身のidを入れ、room_idカラムには今作ったルームのidを保存し@entry1に格納。
    @entry1 = Entry.create(user_id: current_user.id, room_id: @room.id)
    # current_userの相手のユーザーの情報をEntriesテーブルに保存できるように許可し、@entry2に格納。
    @entry2 = Entry.create(room_params)
    redirect_to room_path(@room.id)  #作成と同時に移動
  end

  def show
    @room = Room.find(params[:id])  #ひとつのルームを取り出す。
    #Entriesテーブルにログインしているユーザーidとそれに紐づいたルームid探し、データがあるかを確認。
    if Entry.where(user_id: current_user.id,room_id: @room.id).present?
      @messages = @room.messages  #そのルームに紐づいたmessageを格納（過去のやり取りを表示するため）
      @message = Message.new  #新たにメッセージを送れるようインスタンスを生成し格納。
      @entries = @room.entries  #ルームにユーザーの情報を表示するために、そのルームidに紐づいたユーザーを格納。
    else
      redirect_back(fallback_location: root_path)  #前のページに戻る
    end
  end

  private
  def room_params
    params.require(:entry).permit(:user_id, :room_id).merge(room_id: @room.id)
  end

end
