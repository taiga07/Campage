class MessagesController < ApplicationController

  def create
    #rooms/showのform_withで送られてきた中に必要な情報が入っているか確認。
    if Entry.where(user_id: current_user.id, room_id: params[:message][:room_id]).present?
      @message = Message.create(message_params)
    else
      flash[:alert] = "送信に失敗しました。"
    end
    redirect_to room_path(@message.room_id)
  end

  private
  def message_params
    params.require(:message).permit(:user_id, :message, :room_id).merge(user_id: current_user.id)
  end
end
