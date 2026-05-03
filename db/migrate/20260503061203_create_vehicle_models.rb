class CreateVehicleModels < ActiveRecord::Migration[7.0]
  def change
    create_table :vehicle_models, id: :uuid do |t|
      t.string :brand
      t.string :model
      t.decimal :power_hp, precision: 8, scale: 2
      t.decimal :weight_ton, precision: 8, scale: 2
      t.decimal :capacity_m3, precision: 8, scale: 2
      t.boolean :active
     
      t.references :vehicle_type, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
