class CreateWorkOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :work_orders, id: :uuid do |t|
      t.string :code
      t.text :diagnosis
      t.string :diagnosis_result
      t.string :work_order_type
      t.string :status
      t.datetime :scheduled_date
      t.datetime :closed_date
      
      t.references :maintenance, null: false, foreign_key: true, type: :uuid
      t.references :assigned_to, null: false, foreign_key: { to_table: :technicians }, type: :uuid

      t.timestamps
    end
    add_index :work_orders, :code, unique: true
  end
end
