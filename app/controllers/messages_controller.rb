class MessagesController < ApplicationController

  #メッセージの送信ボタンが押され、createアクションを起こす前に、set_roomメソッドを適用させる。
  before_action :set_room, only: [:create]

  def create
    #rooms/showのform_withで送られてきた中に必要な情報が入っているか確認。
    if Entry.where(user_id: current_user.id, room_id: params[:message][:room_id]).present?
      @message = Message.create(message_params)
      if @message.save
        @message = Message.new
        gets_entries_all_messages
        render :messages
      else
        render :error
      end
    else
      flash[:alert] = "送信に失敗しました。"
      render :messages
    end
  end



  private

  def set_room
    @room = Room.find(params[:message][:room_id])  #form_withで送られてきた内容を@roomに格納
  end

  def gets_entries_all_messages
    @messages = @room.messages  #roomに紐づいたメッセージを格納
    @entries = @room.entries  #roomに紐づいたユーザー情報を格納
  end

  def message_params
    #mergeはuser_idにcurrent_userのidを入れcreateする。
    #message.user_id = current_user.id
    params.require(:message).permit(:user_id, :message, :room_id).merge(user_id: current_user.id)
  end


end



