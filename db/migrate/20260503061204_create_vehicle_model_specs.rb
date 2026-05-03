class CreateVehicleModelSpecs < ActiveRecord::Migration[7.0]
  def change
    create_table :vehicle_model_specs, id: :uuid do |t|
      t.string :key
      t.string :value
      t.string :unit
      
      t.references :vehicle_model, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
