class CreateFullObjectReplicas < ActiveRecord::Migration[5.1]
  def change
    create_table :full_object_replicas do |t|
      t.references :full_object
      t.references :cell
      t.integer :status, index: true
      t.boolean :is_backup
      t.timestamps
    end
  end
end
