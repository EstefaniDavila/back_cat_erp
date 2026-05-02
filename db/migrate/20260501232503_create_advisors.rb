class CreateAdvisors < ActiveRecord::Migration[7.0]
  def change
    create_table :advisors, id: :uuid do |t|
      t.string :first_name,                      null: false, default: ""
      t.string :last_name,                       null: false, default: ""
      t.string :full_name,                       null: false, default: ""

      t.string :email,                           null: false, default: ""
      t.string :document_number,                 null: false, default: ""
      t.string :document_type,                   null: false, default: ""

      t.string :code,                            null: false
      t.string :phone
      t.decimal :commission_rate, precision: 5, scale: 2
      t.string :status,                          null: false # active / inactive

      t.timestamps
    end

    add_index :advisors, :document_number, unique: true
    add_index :advisors, :code, unique: true
  end
end