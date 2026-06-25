class AddNotNullConstraintsToStoreReferences < ActiveRecord::Migration[7.1]
  def change
    change_column_null :users, :store_id, false
    change_column_null :posts, :store_id, false
  end
end
