class CreateFullObjects < ActiveRecord::Migration[5.1]
  def change
    create_table :full_objects do |t|
      t.references :user
      t.string :uuid, index: true
      t.integer :size
      t.string :name
      t.integer :backup_size
      t.integer :replica_size
      t.timestamps
    end
  end
end
