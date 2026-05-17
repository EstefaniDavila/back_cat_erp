class AddFieldsToAreaRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :area_requests, :unit_price, :decimal, precision: 12, scale: 2
    add_column :area_requests, :machine_ready, :boolean
  end
end
