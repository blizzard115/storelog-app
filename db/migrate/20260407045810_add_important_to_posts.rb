class AddImportantToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :important, :boolean, default: false, null: false
  end
end
