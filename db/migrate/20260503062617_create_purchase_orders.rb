class CreatePurchaseOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :purchase_orders, id: :uuid do |t|
      t.string :code
      t.string :status
      t.decimal :total, precision: 12,scale: 2
      t.date :expected_date
      t.datetime :received_at
      t.text :notes

      t.references :supplier, null: false, foreign_key: true, type: :uuid
      t.references :requested_by, null: false, foreign_key: { to_table: :users }, type: :uuid
      
      t.timestamps
    end
    add_index :purchase_orders, :code, unique: true
  end
end
