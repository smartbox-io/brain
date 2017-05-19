class CreateUploadTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :upload_tokens do |t|
      t.string :token, index: true
      t.references :user
      t.references :cell
      t.string :remote_ip
      t.timestamps
    end
  end
end
