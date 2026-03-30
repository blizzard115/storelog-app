class AddStoreToUsers < ActiveRecord::Migration[7.1]
  def change
    add_reference :users, :store, foreign_key: true
  end
end
