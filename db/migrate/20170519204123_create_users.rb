class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :username, index: { unique: true }
      t.string :email, index: true
      t.string :password_digest
      t.integer :upload_rate_limit
      t.integer :download_rate_limit
      t.boolean :inactive, index: true
      t.timestamps
    end
  end
end
