class CreateSyncTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :sync_tokens do |t|
      t.string :token, index: true
      t.references :source_cell
      t.references :source_cell_volume
      t.references :target_cell
      t.references :target_cell_volume
      t.references :full_object
      t.integer :status, index: true
      t.timestamps
    end
  end
end
