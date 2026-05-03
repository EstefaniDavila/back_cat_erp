class CreateSupplierProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :supplier_products, id: :uuid do |t|
      
      t.string :supplier_code
      t.decimal :unit_cost, precision: 12,  scale: 2
      t.integer :lead_time_days
      
      t.references :supplier, null: false, foreign_key: true, type: :uuid
      t.references :product, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
