class NotificationsController < ApplicationController
  
  def index
    
    @notifications = current_user.passive_notifications  # 通知をしてくれたユーザーを取得
    @notifications.where(checked: false).each do |no|  # 通知を未確認のものだけ取り出し
      no.update_attributes(checked: true)  # 確認済みにする
    end
  end
  
  
  
end
