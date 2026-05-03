class CreateQuotationComments < ActiveRecord::Migration[7.0]
  def change
    create_table :quotation_comments, id: :uuid do |t|
     
      t.text :message
      
      t.references :quotation, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
