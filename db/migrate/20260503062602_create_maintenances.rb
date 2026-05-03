class CreateMaintenances < ActiveRecord::Migration[7.0]
  def change
    create_table :maintenances, id: :uuid do |t|
      t.string :code
      
      t.text :description
      t.string :maintenance_type
      t.string :priority
      t.string :status
      t.datetime :requested_at
      t.datetime :scheduled_at
      t.datetime :completed_at

      t.references :client, null: false, foreign_key: true, type: :uuid
      t.references :customer_asset, null: true, foreign_key: true, type: :uuid
      t.references :enterprise_vehicle, null: true, foreign_key: { to_table: :vehicles }, type: :uuid
      t.references :quotation, null: true, foreign_key: true, type: :uuid
      t.timestamps
    end
    add_index :maintenances, :code, unique: true
  end
end
