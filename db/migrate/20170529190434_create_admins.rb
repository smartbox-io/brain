class CreateAdmins < ActiveRecord::Migration[5.1]
  def change
    create_table :admins do |t|
      t.string :username, index: { unique: true }
      t.string :email, index: true
      t.string :password_digest
      t.boolean :inactive, index: true, default: false
      t.timestamps
    end
  end
end
