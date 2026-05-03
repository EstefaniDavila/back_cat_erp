class CreateSparePartCompatibilities < ActiveRecord::Migration[7.0]
  def change
    create_table :spare_part_compatibilities, id: :uuid do |t|
      t.references :spare_part, null: false, foreign_key: true, type: :uuid
      t.references :vehicle_model, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
