class CreateSuppliers < ActiveRecord::Migration[7.0]
  def change
    create_table :suppliers, id: :uuid do |t|
      t.string :code
      t.string :business_name
      t.string :document_type
      t.string :document_number
      t.string :contact_name
      t.string :phone
      t.string :email
      t.text :address
      t.string :city
      t.string :status

      t.timestamps
    end
    add_index :suppliers, :code, unique: true
    add_index :suppliers, :document_number, unique: true
  end
end
