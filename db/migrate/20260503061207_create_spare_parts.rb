class CreateSpareParts < ActiveRecord::Migration[7.0]
  def change
    create_table :spare_parts, id: :uuid do |t|
      
      t.string :part_number
      t.string :manufacturer_brand
      t.integer :stock
      t.integer :min_stock
      t.string :sale_unit
      t.boolean :is_critical

      t.references :product, null: false, foreign_key: true, type: :uuid
      t.references :spare_part_category, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end
    add_index :spare_parts, :part_number, unique: true
  end
end
