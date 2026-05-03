class CreateQuotationFiles < ActiveRecord::Migration[7.0]
  def change
    create_table :quotation_files, id: :uuid do |t|
      t.string :file_url
      t.string :file_type
      
      t.references :quotation, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
