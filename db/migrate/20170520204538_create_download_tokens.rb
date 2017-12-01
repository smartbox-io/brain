class CreateDownloadTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :download_tokens do |t|
      t.string :token, index: { unique: true }
      t.references :full_object
      t.references :user
      t.references :cell_volume
      t.string :remote_ip
      t.timestamps
    end
  end
end
