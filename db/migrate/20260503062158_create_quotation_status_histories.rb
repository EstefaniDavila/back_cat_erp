class CreateQuotationStatusHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :quotation_status_histories, id: :uuid do |t|
      t.string :status
     
      t.references :changed_by, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.references :quotation, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
