class CreateClients < ActiveRecord::Migration[7.0]
  def change
    create_table :clients, id: :uuid do |t|
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
      t.string :client_category
      t.date :first_contact_date
      t.date :last_purchase_date

      t.timestamps
    end
    add_index :clients, :code, unique: true
    add_index :clients, :document_number, unique: true
  end
end
