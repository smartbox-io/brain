class CreateCells < ActiveRecord::Migration[5.1]
  def change
    create_table :cells do |t|
      t.string :uuid, index: true
      t.string :fqdn
      t.integer :total_capacity
      t.integer :available_capacity
      t.timestamps
    end
  end
end
