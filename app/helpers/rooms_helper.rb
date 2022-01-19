module RoomsHelper

  def new_message_preview(room)
    message = room.messages.order(updated_at: :desc).limit(1)
    message = message[0]
    if message.present?
      tag.p(message.message)
    else
      tag.p("まだメッセージはありません")
    end
  end

  def opponent_user(room)
    entry = room.entries.where.not(user_id: current_user)
    name = entry[0].user.name
    tag.p(name)
  end
end
