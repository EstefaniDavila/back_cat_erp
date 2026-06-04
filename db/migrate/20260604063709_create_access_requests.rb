class CreateAccessRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :access_requests, id: :uuid do |t|
      t.string :requested_role
      t.string :first_name
      t.string :last_name
      t.string :document_type
      t.string :document_number
      t.string :email
      t.string :phone
      t.string :status, default: 'pending'
      t.references :created_by, null: true, foreign_key: { to_table: :users }, type: :uuid

      t.timestamps
    end
  end
end
