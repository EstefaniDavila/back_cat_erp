class CreateCustomerAssets < ActiveRecord::Migration[7.0]
  def change
    create_table :customer_assets, id: :uuid do |t|
      t.string :asset_type
      t.string :name
      t.string :brand
      t.string :asset_model
      t.string :serial_number
      t.integer :year
      t.text :description
      t.string :status
      
      t.references :client, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
