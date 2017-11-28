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
  end
end
