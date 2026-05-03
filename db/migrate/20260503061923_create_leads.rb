class CreateLeads < ActiveRecord::Migration[7.0]
  def change
    create_table :leads, id: :uuid do |t|
      t.string :code
      t.string :name
      t.string :email
      t.string :phone
      t.string :source
      t.string :lead_type
      t.string :status
      t.string :priority
      t.text :notes

      t.references :assigned_to, null: false, foreign_key: { to_table: :advisors }, type: :uuid
      t.references :client, null: true, foreign_key: true, type: :uuid
      t.timestamps
    end
    add_index :leads, :code, unique: true
  end
end
