class CreateDispatchOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :dispatch_orders, id: :uuid do |t|
      t.string :code
      
      t.string :status
      t.datetime :dispatched_at
      t.datetime :delivered_at
     
      t.references :prepared_by, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.references :sales_order, null: true, foreign_key: true, type: :uuid
      t.references :rental, null: true, foreign_key: true, type: :uuid
      
      t.timestamps
    end
    add_index :dispatch_orders, :code, unique: true
  end
end
