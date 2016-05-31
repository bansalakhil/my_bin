class AddTestsToJsBin < ActiveRecord::Migration[5.0]
  def change
    add_column :js_bins, :tests, :text
  end
end
