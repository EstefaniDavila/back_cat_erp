class CreateAreaRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :area_requests, id: :uuid do |t|
      t.string :area
      t.string :name
      t.text :description
      t.string :status
      
      t.datetime :reviewed_at
      t.text :notes
      
      t.references :quotation, null: false, foreign_key: true, type: :uuid
      t.references :created_by, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.references :reviewed_by, null: true, foreign_key: { to_table: :users }, type: :uuid
      t.timestamps
    end
  end
end
