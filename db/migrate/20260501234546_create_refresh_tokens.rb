class CreateRefreshTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :refresh_tokens, id: :uuid  do |t|
      t.string :token
      t.references :user,type: :uuid, null: false, foreign_key: true
      t.datetime :expire_at

      t.timestamps
    end
    add_index :refresh_tokens, :token, unique: true
  end
end
