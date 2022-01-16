class Post < ApplicationRecord
  #postモデルでimpressionistを使用できるようにする。
  is_impressionable counter_cache: true

  belongs_to :user

  has_many :post_images, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :notifications, dependent: :destroy

  # postモデルを使ってpost_imagesテーブルにあるimage_idカラムに画像を保存すると言う解釈かな
  accepts_attachments_for :post_images, attachment: :image

  def liked_by?(user)
    # likesテーブル内のuser_idにuser.idが存在しているか確認している。
    # 存在していればtrue、存在していなければfalseを返す。
    likes.where(user_id: user.id).exists?
  end

  #通知メソッド
  #メソッド内の！はデータの登録をおこなっていることをわかりやすくするため。
  def create_notification_like!(current_user)
    # 過去にいいねをしたことがあるか確認
    temp = Notification.where(["visiter_id = ? and visited_id = ? and post_id = ? and action = ? ", current_user.id, user_id, id, 'like'])
    # 初めてのいいねの場合、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(post_id: id, visited_id: user_id, action: "like")
      # 自分の投稿に対するいいねは通知を送らない
      if notification.visiter_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

  def create_notification_comment!(current_user, comment_id)
    # 自分以外にコメントしている人を取得し通知
    temp_ids = Comment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, comment_id, temp_id['user_id'])
    end
    # 誰もコメントしていなければ、投稿者に送る
    save_notification_comment!(current_user, comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment!(current_user, comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(post_id: id, comment_id: comment_id, visited_id: visited_id, action: 'comment')
    # 自分の投稿に対するコメントの場合は、通知を送らない
    if notification.visiter_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end



end
