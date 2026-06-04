class CreateInformationRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :information_requests, id: :uuid do |t|
      t.references :client, null: true, foreign_key: true, type: :uuid
      t.string :name
      t.string :phone
      t.string :subject
      t.text :message
      t.string :status, default: 'pending'
      t.text :response
      t.references :advisor, null: true, foreign_key: { to_table: :users }, type: :uuid

      t.timestamps
    end
  end
end
