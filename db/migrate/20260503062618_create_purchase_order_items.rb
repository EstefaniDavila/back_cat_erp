class CreatePurchaseOrderItems < ActiveRecord::Migration[7.0]
  def change
    create_table :purchase_order_items, id: :uuid do |t|
      
      t.integer :quantity
      t.decimal :unit_cost, precision: 12,  scale: 2
      t.decimal :total_cost, precision: 12,  scale: 2
      t.integer :received_quantity
      
      t.references :purchase_order, null: false, foreign_key: true, type: :uuid
      t.references :product, null: false, foreign_key: true, type: :uuid
      
      t.timestamps
    end
  end
end
