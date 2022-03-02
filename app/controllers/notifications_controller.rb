class NotificationsController < ApplicationController
  
  before_action :authenticate_user!

  def index
    # 通知をしてくれたユーザーを取得
    @notifications = current_user.passive_notifications.page(params[:page]).per(10)
    # 通知を未確認のものだけ取り出し確認済み
    @notifications.where(checked: false).each do |no|
      no.update_attributes(checked: true)
    end
  end

end
