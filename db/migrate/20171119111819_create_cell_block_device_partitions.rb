class CreateCellBlockDevicePartitions < ActiveRecord::Migration[5.1]
  def change
    create_table :cell_block_device_partitions do |t|
      t.references :cell_block_device
      t.string :partition
      t.integer :total_capacity
      t.timestamps
    end
  end
end
