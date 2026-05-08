class CreateQuotations < ActiveRecord::Migration[7.0]
  def change
    create_table :quotations, id: :uuid do |t|
      t.string :code
      
      t.string :quotation_type
      t.string :status
      t.decimal :subtotal, precision: 12, scale: 2
      t.decimal :tax, precision: 12,  scale: 2
      t.decimal :total, precision: 12, scale: 2
      t.date :valid_until
      t.datetime :sent_at
      t.datetime :approved_at
      t.datetime :rejected_at

      t.references :client, null: false, foreign_key: true, type: :uuid
      t.references :advisor, null: true, foreign_key: true, type: :uuid
      t.references :lead, null: true, foreign_key: true, type: :uuid
      t.timestamps
    end
    add_index :quotations, :code, unique: true
  end
end
