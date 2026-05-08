class CreateActivityLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :activity_logs, id: :uuid do |t|
      t.references :user, uuid: true, null: false, foreign_key: true, type: :uuid
      t.string :action
      t.string :browser
      t.string :ip_address
      t.text :note

      t.timestamps
    end
  end
end
