class CreateSparePartSpecs < ActiveRecord::Migration[7.0]
  def change
    create_table :spare_part_specs, id: :uuid do |t|
      t.string :key
      t.string :value
      t.string :unit

      t.references :spare_part, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
