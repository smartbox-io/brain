class CreateUploadTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :upload_tokens do |t|
      t.string :token, index: { unique: true }
      t.references :user
      t.references :cell_volume
      t.string :remote_ip
      t.timestamps
    end
  end
end
