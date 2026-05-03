class CreateSalesOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :sales_orders, id: :uuid do |t|
      t.string :code
     
      t.string :status
      t.decimal :total, precision: 12, scale: 2
      t.text :notes
      
      t.references :quotation, null: false, foreign_key: true, type: :uuid
      t.references :client, null: false, foreign_key: true, type: :uuid
      t.references :advisor, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end
    add_index :sales_orders, :code, unique: true
  end
end
