class CreateWarehousemen < ActiveRecord::Migration[7.0]
  def change
    create_table :warehousemen, id: :uuid do |t|
      t.string :first_name
      t.string :last_name
      t.string :full_name
      t.string :email
      t.string :document_number
      t.string :document_type
      t.string :position

      t.timestamps
    end
    add_index :warehousemen, :document_number, unique: true
  end
end
