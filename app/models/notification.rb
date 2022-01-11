class Notification < ApplicationRecord

  default_scope -> {order(created_at: :desc)}  #新着順に表示する。

  # optional: trueはnilを許容する記述
  # フォローの際にpostやcommentは関係ないのでnilが入る。
  belongs_to :post, optional: true
  belongs_to :comment, optional: true
  belongs_to :visiter, class_name: "User", foreign_key: "visiter_id", optional: true
  belongs_to :visited, class_name: "User", foreign_key: "visited_id", optional: true

end
