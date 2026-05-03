class CreateDispatchItems < ActiveRecord::Migration[7.0]
  def change
    create_table :dispatch_items, id: :uuid do |t|
     
      t.integer :quantity
      t.boolean :checked

      t.references :dispatch_order, null: false, foreign_key: true, type: :uuid
      t.references :product, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
