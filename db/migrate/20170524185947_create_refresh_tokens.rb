class CreateRefreshTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :refresh_tokens do |t|
      t.references :user
      t.string :token, index: { unique: true }
      t.timestamps
    end
  end
end
