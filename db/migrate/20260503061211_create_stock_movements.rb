class CreateStockMovements < ActiveRecord::Migration[7.0]
  def change
    create_table :stock_movements, id: :uuid do |t|
      t.string :movement_type
      t.integer :quantity
      t.string :reference
    
      t.references :performed_by, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.references :spare_part, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
