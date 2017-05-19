class CreateFullObjectTags < ActiveRecord::Migration[5.1]
  def change
    create_table :full_object_tags do |t|
      t.references :full_object
      t.references :tag
      t.timestamps
    end
  end
end
