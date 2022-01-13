class NotificationsController < ApplicationController
  
  def index
    @notifications = current_user.passive_notifications
    @notifications.where(checked: false).each do |no|
      no.update_attributes(checked: true)
    end
  end
  
  
  
end
