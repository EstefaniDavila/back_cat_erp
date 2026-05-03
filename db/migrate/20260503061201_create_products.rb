class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products, id: :uuid do |t|
      t.string :product_type
      t.string :code
      t.string :name
      t.text :description
      t.decimal :base_price, precision: 12, scale: 2
      t.boolean :active
      
      t.references :created_by, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.references :updated_by, null: false, foreign_key: { to_table: :users }, type: :uuid

      t.timestamps
    end
    add_index :products, :code, unique: true
  end
end
