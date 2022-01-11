class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attachment :profile_image

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy
  # Relationshipモデルをfollowerとfollowedの二つに分ける。
  # followerモデルはfollower_idのデータが入る。
  # フォローする側から見てフォローされる側のデータを取得する。（フォローした相手のデータ）
  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # followedモデルはfollowed_idのデータが入る。
  # フォローされる側から見てフォローしてくる側を取得する。（フォローされた相手のデータ）
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # フォローする人は中間テーブル(Relationshipのfollower)を通じて(through)、フォローされる人と紐づく(followed)
  has_many :following_user, through: :follower, source: :followed #自分がフォローしている人を取得
  # フォローされる人は中間テーブル(Relationshipのfollowed)を通じて、フォローする人と紐づく(follower)
  has_many :follower_user, through: :followed, source: :follower #自分をフォローしている人を取得

  # 通知を送ったユーザー（visiter_idを参考にactive_notificationsモデルにアクセスする。）
  has_many :active_notifications, class_name: "Notification", foreign_key: "visiter_id", dependent: :destroy
  # 通知をもらったユーザー（visited_idを参考にpassive_notificationsモデルにアクセスする。）
  has_many :passive_notifications, class_name: "Notification", foreign_key: "visited_id", dependent: :destroy

  # ユーザーをフォローする
  def follow(user_id)
    follower.create(followed_id: user_id)
  end

  # ユーザーのフォローを外す
  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end

  # フォローしていればtrueを返す
  def following?(user)
    following_user.include?(user)
  end

  # 通知メソッド
  def create_notification_follow!(current_user)
    temp = Notification.where(["visiter_id = ? and visited_id = ? and action = ? ",current_user.id, id, 'follow'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end

end
