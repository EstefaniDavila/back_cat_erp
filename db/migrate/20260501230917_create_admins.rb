class CreateAdmins < ActiveRecord::Migration[7.0]
  def change
    create_table :admins, id: :uuid do |t|
      t.string :first_name,                 null: false, default: ""
      t.string :last_name,                  null: false, default: ""
      t.string :full_name,                  null: false, default: ""

      t.string :email,                      null: false, default: ""
      t.string :document_number,            null: false, default: ""
      t.string :document_type,              null: false, default: ""

      t.timestamps
    end

    add_index :admins, :document_number, unique: true
  end
end