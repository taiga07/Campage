class Relationship < ApplicationRecord
  # followerやfollowedテーブルは存在せずUserテーブルを参照したいので、指定する。
  # Userモデルをfollowerとfollowesの二つに分けているイメージ
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
end
