class CreateStores < ActiveRecord::Migration[7.1]
  def change
    create_table :stores do |t|
      t.string :name
      t.string :email
      t.string :store_code

      t.timestamps
    end
  end
end
