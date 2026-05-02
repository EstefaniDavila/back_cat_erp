class CreateLogisticsUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :logistics_users, id: :uuid do |t|
      t.string :first_name,                      null: false, default: ""
      t.string :last_name,                       null: false, default: ""
      t.string :full_name,                       null: false, default: ""

      t.string :email,                           null: false, default: ""
      t.string :document_number,                 null: false, default: ""
      t.string :document_type,                   null: false, default: ""

      t.string :position

      t.timestamps
    end

    add_index :logistics_users, :document_number, unique: true
  end
end