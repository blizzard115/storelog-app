class AddUniqueIndexesToReadsAndStores < ActiveRecord::Migration[7.1]
  def change
    add_index :reads,
              [:user_id, :post_id],
              unique: true,
              name: "index_reads_on_user_id_and_post_id"

    add_index :stores, :store_code, unique: true
  end
end