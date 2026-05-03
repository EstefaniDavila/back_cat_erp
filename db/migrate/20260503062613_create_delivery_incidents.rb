class CreateDeliveryIncidents < ActiveRecord::Migration[7.0]
  def change
    create_table :delivery_incidents, id: :uuid do |t|
      t.string :incident_type
      t.text :description
      
      t.references :reported_by, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.references :delivery_guide, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
