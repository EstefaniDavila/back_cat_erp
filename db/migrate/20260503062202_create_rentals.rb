class CreateRentals < ActiveRecord::Migration[7.0]
  def change
    create_table :rentals, id: :uuid do |t|
      t.string :code
      t.date :start_date
      t.date :end_date
      t.string :status
      t.datetime :delivery_date
      t.datetime :return_date
      t.text :vehicle_condition_delivery
      t.text :vehicle_condition_return
      t.decimal :total, precision: 12,  scale: 2
      t.text :notes
      
      t.references :quotation, null: false, foreign_key: true, type: :uuid
      t.references :client, null: false, foreign_key: true, type: :uuid
      t.references :vehicle, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end
    add_index :rentals, :code, unique: true
  end
end
