class CreateBlacklistedTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :blacklisted_tokens, id: :uuid  do |t|
      t.string :token
      t.datetime :expire_at
      t.references :user,type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end