class CreatePostImages < ActiveRecord::Migration[5.2]
  def change
    create_table :post_images do |t|
      
      t.integer :post_id, :null => false
      t.string :images_id, :null => false
      t.timestamps
    end
  end
end
