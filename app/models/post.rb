class Post < ApplicationRecord

  belongs_to :user

  has_many :post_images, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  # postモデルを使ってpost_imagesテーブルにあるimage_idカラムに画像を保存すると言う解釈かな
  accepts_attachments_for :post_images, attachment: :image

  def liked_by?(user)
    # likesテーブル内のuser_idにuser.idが存在しているか確認している。
    # 存在していればtrue、存在していなければfalseを返す。
    likes.where(user_id: user.id).exists?
  end

end
