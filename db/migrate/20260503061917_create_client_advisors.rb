class CreateClientAdvisors < ActiveRecord::Migration[7.0]
  def change
    create_table :client_advisors, id: :uuid do |t|
     
      t.string :role
      t.boolean :active
      t.datetime :assigned_at
      
      t.references :client, null: false, foreign_key: true, type: :uuid
      t.references :advisor, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
