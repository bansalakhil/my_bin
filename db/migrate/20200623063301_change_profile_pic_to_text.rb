class ChangeProfilePicToText < ActiveRecord::Migration[5.0]
  def up
    change_column :users, :profile_pic, :text
  end

  def down
    change_column :users, :profile_pic, :string
  end

end
