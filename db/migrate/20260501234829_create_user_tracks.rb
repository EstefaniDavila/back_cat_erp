class CreateUserTracks < ActiveRecord::Migration[7.0]
  def change
    create_table :user_tracks, id: :uuid  do |t|
        t.string :os_data
        t.string :remote_ip
        t.string :browser_data
        t.string :aud
        
        t.references :user,type: :uuid, null: false, foreign_key: true
      t.timestamps
    end
  end
end