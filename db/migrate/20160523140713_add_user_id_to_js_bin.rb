class AddUserIdToJsBin < ActiveRecord::Migration[5.0]
  def change
    add_column :js_bins, :user_id, :integer
    add_index :js_bins, :user_id
  end
end
