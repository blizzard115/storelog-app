class ChangePostsForTechLog < ActiveRecord::Migration[7.1]
  def change
    change_column :posts, :content, :text

    add_column :posts, :post_type, :integer, null: false, default: 0
    add_column :posts, :status, :integer, null: false, default: 0
    add_column :posts, :is_public, :boolean, null: false, default: true
  end
end