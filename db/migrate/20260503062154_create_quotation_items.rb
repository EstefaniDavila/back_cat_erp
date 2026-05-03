class CreateQuotationItems < ActiveRecord::Migration[7.0]
  def change
    create_table :quotation_items, id: :uuid do |t|
      
      t.text :description
      t.integer :quantity
      t.decimal :unit_price, precision: 12, scale: 2
      t.decimal :total_price, precision: 12, scale: 2
      t.string :item_type

      t.references :quotation, null: false, foreign_key: true, type: :uuid
      t.references :product, null: true, foreign_key: true, type: :uuid
      t.references :customer_asset, null: true, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
