class ChangeTokenToTextInUsers < ActiveRecord::Migration[5.0]
  def up
    change_column :users, :token, :text
  end

  def down
    change_column :users, :token, :string
  end
end
