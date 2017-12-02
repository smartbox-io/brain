class CreateCellVolumes < ActiveRecord::Migration[5.1]
  def change
    create_table :cell_volumes do |t|
      t.references :cell_block_device
      t.string :volume
      t.integer :total_capacity, limit: 8
      t.integer :available_capacity, limit: 8
      t.integer :status
      t.timestamps
    end
    add_index :cell_volumes, [:cell_block_device_id, :volume], unique: true
  end
end
