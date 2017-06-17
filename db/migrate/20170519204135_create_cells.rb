class CreateCells < ActiveRecord::Migration[5.1]
  def change
    create_table :cells do |t|
      t.string :uuid, index: true
      t.string :fqdn
      t.string :ip_address
      t.integer :status
      t.timestamps
    end
  end
end
