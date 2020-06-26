class CreateMysqlBin < ActiveRecord::Migration[5.0]
  def change
    create_table :mysql_bins do |t|
      t.string   "title"
      t.longtext "queries"
      t.longtext "schema"
      t.integer  "user_id"
      t.datetime "created_at",               null: false
      t.datetime "updated_at",               null: false
      t.index ["user_id"], name: "index_mysql_bins_on_user_id", using: :btree


    end
  end
end
