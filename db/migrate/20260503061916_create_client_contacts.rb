class CreateClientContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :client_contacts, id: :uuid do |t|
      t.string :name
      t.string :position
      t.string :phone
      t.string :email
      t.boolean :is_primary
      t.references :client, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
