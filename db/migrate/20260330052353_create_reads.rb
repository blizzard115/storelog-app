class CreateReads < ActiveRecord::Migration[7.1]
  def change
    create_table :reads do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
  end
end
