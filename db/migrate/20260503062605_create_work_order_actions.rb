class CreateWorkOrderActions < ActiveRecord::Migration[7.0]
  def change
    create_table :work_order_actions, id: :uuid do |t|
      t.string :action
      t.text :description
      t.string :evidence
      
      t.references :performed_by, null: false, foreign_key: { to_table: :technicians }, type: :uuid
      t.references :work_order, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
