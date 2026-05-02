class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email,                          null: false, default: ""
      t.string :password_digest,                null: false, default: ""
      t.integer :status

      t.string :avatar
      t.string :phone
      t.string :document_number,                null: false, default: ""

      t.references :roleable, polymorphic: true, type: :uuid, null: false 

      t.timestamps
    end
    add_index :users, :email,                  unique: true
    add_index :users, :document_number,        unique: true
    add_index :users, :phone,                  unique: true

  end
end