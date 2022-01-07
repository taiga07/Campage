class RenameImagesIdColumnToPostImages < ActiveRecord::Migration[5.2]
  def change
    rename_column :post_images, :images_id, :image_id
  end
end
