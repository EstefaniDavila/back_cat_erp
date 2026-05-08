class CreateVehicles < ActiveRecord::Migration[7.0]
  def change
    create_table :vehicles, id: :uuid do |t|
      
      t.string :serial
      t.integer :manufacture_year
      t.decimal :hours_used, precision: 10, scale: 2
      t.string :status
      t.decimal :price_per_hour, precision: 12, scale: 2
      t.decimal :price_per_day, precision: 12, scale: 2
      t.string :location


      t.references :product, null: false, foreign_key: true, type: :uuid
      t.references :vehicle_model, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end
    add_index :vehicles, :serial, unique: true
  end
end
