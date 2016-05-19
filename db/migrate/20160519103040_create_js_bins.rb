class CreateJsBins < ActiveRecord::Migration[5.0]
  def change
    create_table :js_bins do |t|
      t.text :html
      t.text :css
      t.text :js

      t.timestamps
    end
  end
end
