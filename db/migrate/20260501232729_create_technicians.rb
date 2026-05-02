class CreateTechnicians < ActiveRecord::Migration[7.0]
  def change
    create_table :technicians, id: :uuid do |t|
      t.string :first_name,                      null: false, default: ""
      t.string :last_name,                       null: false, default: ""
      t.string :full_name,                       null: false, default: ""

      t.string :email,                           null: false, default: ""
      t.string :document_number,                 null: false, default: ""
      t.string :document_type,                   null: false, default: ""

      t.string :specialty
      t.text :certification
      t.string :status,                          null: false

      t.timestamps
    end

    add_index :technicians, :document_number, unique: true
  end
end