class Post < ApplicationRecord

  belongs_to :user

  has_many :post_images,dependent: :destroy
  has_many :comments, dependent: :destroy
  # postモデルを使ってpost_imagesテーブルにあるimage_idカラムに画像を保存すると言う解釈かな
  accepts_attachments_for :post_images, attachment: :image

end
