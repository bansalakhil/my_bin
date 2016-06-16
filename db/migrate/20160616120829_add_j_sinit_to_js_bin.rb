class AddJSinitToJsBin < ActiveRecord::Migration[5.0]
  def change
    add_column :js_bins, :js_init, :text
  end
end
