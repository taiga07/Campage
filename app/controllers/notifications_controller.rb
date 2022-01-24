class NotificationsController < ApplicationController
  
  before_action :authenticate_user!

  def index

    @notifications = current_user.passive_notifications.page(params[:page]).per(10)
    @notifications.where(checked: false).each do |no|
      no.update_attributes(checked: true)
    end
  end



end
