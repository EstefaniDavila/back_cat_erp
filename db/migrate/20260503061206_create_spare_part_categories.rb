class CreateSparePartCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :spare_part_categories, id: :uuid do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
