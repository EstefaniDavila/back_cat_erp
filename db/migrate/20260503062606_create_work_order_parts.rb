class CreateWorkOrderParts < ActiveRecord::Migration[7.0]
  def change
    create_table :work_order_parts, id: :uuid do |t|
     
      t.integer :quantity
      t.decimal :unit_price, precision: 12,  scale: 2
      
      t.references :work_order, null: false, foreign_key: true, type: :uuid
      t.references :product, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
