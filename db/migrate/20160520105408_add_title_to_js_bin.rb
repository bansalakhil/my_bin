class AddTitleToJsBin < ActiveRecord::Migration[5.0]
  def change
    add_column :js_bins, :title, :string
  end
end
