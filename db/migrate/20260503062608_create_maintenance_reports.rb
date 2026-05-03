class CreateMaintenanceReports < ActiveRecord::Migration[7.0]
  def change
    create_table :maintenance_reports, id: :uuid do |t|
      t.text :summary
      t.text :details
      t.text :recommendations
      
      t.references :created_by, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.references :maintenance, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
