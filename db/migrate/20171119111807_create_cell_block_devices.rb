class CreateCellBlockDevices < ActiveRecord::Migration[5.1]
  def change
    create_table :cell_block_devices do |t|
      t.references :cell
      t.string :device
      t.integer :total_capacity, limit: 8
      t.integer :available_capacity, limit: 8
      t.integer :status
      t.timestamps
    end
    add_index :cell_block_devices, [:cell_id, :device], unique: true
  end
end
