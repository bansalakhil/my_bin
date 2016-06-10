class CreateRubyBins < ActiveRecord::Migration[5.0]
  def change
    create_table :ruby_bins do |t|
      t.string :title
      t.text :code
      t.text :input
      t.text :tests
      t.belongs_to :user

      t.timestamps
    end
  end
end
