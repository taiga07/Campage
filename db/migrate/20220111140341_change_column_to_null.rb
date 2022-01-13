class ChangeColumnToNull < ActiveRecord::Migration[5.2]

  def up
    change_column_null :notifications, :post_id, true
    change_column_null :notifications, :comment_id, true
  end

  def down
    change_column_null :notifications, :post_id, false
    change_column_null :notifications, :comment_id, false
  end

end
