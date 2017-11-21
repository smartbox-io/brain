class CreateCellVolumes < ActiveRecord::Migration[5.1]
  def change
    create_table :cell_volumes do |t|
      t.references :cell_block_device
      t.string :partition
      t.integer :total_capacity
      t.integer :available_capacity
      t.timestamps
    end
  end
end
