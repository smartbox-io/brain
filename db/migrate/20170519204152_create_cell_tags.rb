class CreateCellTags < ActiveRecord::Migration[5.1]
  def change
    create_table :cell_tags do |t|
      t.references :cell
      t.references :tag
      t.timestamps
    end
  end
end
