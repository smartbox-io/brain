class CreateTags < ActiveRecord::Migration[5.1]
  def change
    create_table :tags do |t|
      t.string :name
      t.string :color
      t.boolean :visible, index: true, default: true
      t.timestamps
    end
  end
end
