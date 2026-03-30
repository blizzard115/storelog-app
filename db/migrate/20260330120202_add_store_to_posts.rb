class AddStoreToPosts < ActiveRecord::Migration[7.1]
  def change
    add_reference :posts, :store, foreign_key: true
  end
end
