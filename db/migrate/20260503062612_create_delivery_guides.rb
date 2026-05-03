class CreateDeliveryGuides < ActiveRecord::Migration[7.0]
  def change
    create_table :delivery_guides, id: :uuid do |t|
      t.string :guide_number
      t.text :destination_address
      t.datetime :issued_at
      t.datetime :delivered_at
      t.string :status
      
      t.references :dispatch_order, null: false, foreign_key: true, type: :uuid
      t.references :driver, null: false, foreign_key: { to_table: :logistics_users }, type: :uuid
      t.references :vehicle, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
    add_index :delivery_guides, :guide_number, unique: true
  end
end
