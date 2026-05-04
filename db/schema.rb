# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2026_05_03_062623) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "full_name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "document_number", default: "", null: false
    t.string "document_type", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_number"], name: "index_admins_on_document_number", unique: true
  end

  create_table "advisors", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "full_name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "document_number", default: "", null: false
    t.string "document_type", default: "", null: false
    t.string "code", null: false
    t.string "phone"
    t.decimal "commission_rate", precision: 5, scale: 2
    t.string "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_advisors_on_code", unique: true
    t.index ["document_number"], name: "index_advisors_on_document_number", unique: true
  end

  create_table "area_requests", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "area"
    t.string "name"
    t.text "description"
    t.string "status"
    t.datetime "reviewed_at"
    t.text "notes"
    t.uuid "quotation_id", null: false
    t.uuid "created_by_id", null: false
    t.uuid "reviewed_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_area_requests_on_created_by_id"
    t.index ["quotation_id"], name: "index_area_requests_on_quotation_id"
    t.index ["reviewed_by_id"], name: "index_area_requests_on_reviewed_by_id"
  end

  create_table "blacklisted_tokens", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "token"
    t.uuid "user_id", null: false
    t.datetime "expire_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_blacklisted_tokens_on_user_id"
  end

  create_table "client_advisors", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "role"
    t.boolean "active"
    t.datetime "assigned_at"
    t.uuid "client_id", null: false
    t.uuid "advisor_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["advisor_id"], name: "index_client_advisors_on_advisor_id"
    t.index ["client_id"], name: "index_client_advisors_on_client_id"
  end

  create_table "client_contacts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "position"
    t.string "phone"
    t.string "email"
    t.boolean "is_primary"
    t.uuid "client_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_client_contacts_on_client_id"
  end

  create_table "clients", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "code"
    t.string "business_name"
    t.string "document_type"
    t.string "document_number"
    t.string "contact_name"
    t.string "phone"
    t.string "email"
    t.text "address"
    t.string "city"
    t.string "status"
    t.string "client_category"
    t.date "first_contact_date"
    t.date "last_purchase_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_clients_on_code", unique: true
    t.index ["document_number"], name: "index_clients_on_document_number", unique: true
  end

  create_table "customer_assets", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "asset_type"
    t.string "name"
    t.string "brand"
    t.string "asset_model"
    t.string "serial_number"
    t.integer "year"
    t.text "description"
    t.string "status"
    t.uuid "client_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_customer_assets_on_client_id"
  end

  create_table "delivery_guides", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "guide_number"
    t.text "destination_address"
    t.datetime "issued_at"
    t.datetime "delivered_at"
    t.string "status"
    t.uuid "dispatch_order_id", null: false
    t.uuid "driver_id", null: false
    t.uuid "vehicle_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dispatch_order_id"], name: "index_delivery_guides_on_dispatch_order_id"
    t.index ["driver_id"], name: "index_delivery_guides_on_driver_id"
    t.index ["guide_number"], name: "index_delivery_guides_on_guide_number", unique: true
    t.index ["vehicle_id"], name: "index_delivery_guides_on_vehicle_id"
  end

  create_table "delivery_incidents", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "incident_type"
    t.text "description"
    t.uuid "reported_by_id", null: false
    t.uuid "delivery_guide_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["delivery_guide_id"], name: "index_delivery_incidents_on_delivery_guide_id"
    t.index ["reported_by_id"], name: "index_delivery_incidents_on_reported_by_id"
  end

  create_table "dispatch_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "quantity"
    t.boolean "checked"
    t.uuid "dispatch_order_id", null: false
    t.uuid "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dispatch_order_id"], name: "index_dispatch_items_on_dispatch_order_id"
    t.index ["product_id"], name: "index_dispatch_items_on_product_id"
  end

  create_table "dispatch_orders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "code"
    t.string "status"
    t.datetime "dispatched_at"
    t.datetime "delivered_at"
    t.uuid "prepared_by_id", null: false
    t.uuid "sales_order_id"
    t.uuid "rental_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_dispatch_orders_on_code", unique: true
    t.index ["prepared_by_id"], name: "index_dispatch_orders_on_prepared_by_id"
    t.index ["rental_id"], name: "index_dispatch_orders_on_rental_id"
    t.index ["sales_order_id"], name: "index_dispatch_orders_on_sales_order_id"
  end

  create_table "lead_comments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "message"
    t.uuid "lead_id", null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lead_id"], name: "index_lead_comments_on_lead_id"
    t.index ["user_id"], name: "index_lead_comments_on_user_id"
  end

  create_table "lead_status_histories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "status"
    t.uuid "changed_by_id", null: false
    t.uuid "lead_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["changed_by_id"], name: "index_lead_status_histories_on_changed_by_id"
    t.index ["lead_id"], name: "index_lead_status_histories_on_lead_id"
  end

  create_table "leads", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "source"
    t.string "lead_type"
    t.string "status"
    t.string "priority"
    t.text "notes"
    t.uuid "assigned_to_id", null: false
    t.uuid "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assigned_to_id"], name: "index_leads_on_assigned_to_id"
    t.index ["client_id"], name: "index_leads_on_client_id"
    t.index ["code"], name: "index_leads_on_code", unique: true
  end

  create_table "logistics_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "full_name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "document_number", default: "", null: false
    t.string "document_type", default: "", null: false
    t.string "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_number"], name: "index_logistics_users_on_document_number", unique: true
  end

  create_table "maintenance_reports", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "summary"
    t.text "details"
    t.text "recommendations"
    t.uuid "created_by_id", null: false
    t.uuid "maintenance_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_maintenance_reports_on_created_by_id"
    t.index ["maintenance_id"], name: "index_maintenance_reports_on_maintenance_id"
  end

  create_table "maintenances", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "code"
    t.text "description"
    t.string "maintenance_type"
    t.string "priority"
    t.string "status"
    t.datetime "requested_at"
    t.datetime "scheduled_at"
    t.datetime "completed_at"
    t.uuid "client_id", null: false
    t.uuid "customer_asset_id"
    t.uuid "enterprise_vehicle_id"
    t.uuid "quotation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_maintenances_on_client_id"
    t.index ["code"], name: "index_maintenances_on_code", unique: true
    t.index ["customer_asset_id"], name: "index_maintenances_on_customer_asset_id"
    t.index ["enterprise_vehicle_id"], name: "index_maintenances_on_enterprise_vehicle_id"
    t.index ["quotation_id"], name: "index_maintenances_on_quotation_id"
  end

  create_table "managers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "full_name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "document_number", default: "", null: false
    t.string "document_type", default: "", null: false
    t.string "area", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_number"], name: "index_managers_on_document_number", unique: true
  end

  create_table "product_images", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "url"
    t.uuid "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_images_on_product_id"
  end

  create_table "products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "product_type"
    t.string "code"
    t.string "name"
    t.text "description"
    t.decimal "base_price", precision: 12, scale: 2
    t.boolean "active"
    t.uuid "created_by_id", null: false
    t.uuid "updated_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_products_on_code", unique: true
    t.index ["created_by_id"], name: "index_products_on_created_by_id"
    t.index ["updated_by_id"], name: "index_products_on_updated_by_id"
  end

  create_table "purchase_order_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "quantity"
    t.decimal "unit_cost", precision: 12, scale: 2
    t.decimal "total_cost", precision: 12, scale: 2
    t.integer "received_quantity"
    t.uuid "purchase_order_id", null: false
    t.uuid "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_purchase_order_items_on_product_id"
    t.index ["purchase_order_id"], name: "index_purchase_order_items_on_purchase_order_id"
  end

  create_table "purchase_orders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "code"
    t.string "status"
    t.decimal "total", precision: 12, scale: 2
    t.date "expected_date"
    t.datetime "received_at"
    t.text "notes"
    t.uuid "supplier_id", null: false
    t.uuid "requested_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_purchase_orders_on_code", unique: true
    t.index ["requested_by_id"], name: "index_purchase_orders_on_requested_by_id"
    t.index ["supplier_id"], name: "index_purchase_orders_on_supplier_id"
  end

  create_table "quotation_comments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "message"
    t.uuid "quotation_id", null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quotation_id"], name: "index_quotation_comments_on_quotation_id"
    t.index ["user_id"], name: "index_quotation_comments_on_user_id"
  end

  create_table "quotation_files", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "file_url"
    t.string "file_type"
    t.uuid "quotation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quotation_id"], name: "index_quotation_files_on_quotation_id"
  end

  create_table "quotation_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "description"
    t.integer "quantity"
    t.decimal "unit_price", precision: 12, scale: 2
    t.decimal "total_price", precision: 12, scale: 2
    t.string "item_type"
    t.uuid "quotation_id", null: false
    t.uuid "product_id"
    t.uuid "customer_asset_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_asset_id"], name: "index_quotation_items_on_customer_asset_id"
    t.index ["product_id"], name: "index_quotation_items_on_product_id"
    t.index ["quotation_id"], name: "index_quotation_items_on_quotation_id"
  end

  create_table "quotation_status_histories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "status"
    t.uuid "changed_by_id", null: false
    t.uuid "quotation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["changed_by_id"], name: "index_quotation_status_histories_on_changed_by_id"
    t.index ["quotation_id"], name: "index_quotation_status_histories_on_quotation_id"
  end

  create_table "quotations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "code"
    t.string "quotation_type"
    t.string "status"
    t.decimal "subtotal", precision: 12, scale: 2
    t.decimal "tax", precision: 12, scale: 2
    t.decimal "total", precision: 12, scale: 2
    t.date "valid_until"
    t.datetime "sent_at"
    t.datetime "approved_at"
    t.datetime "rejected_at"
    t.uuid "client_id", null: false
    t.uuid "advisor_id", null: false
    t.uuid "lead_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["advisor_id"], name: "index_quotations_on_advisor_id"
    t.index ["client_id"], name: "index_quotations_on_client_id"
    t.index ["code"], name: "index_quotations_on_code", unique: true
    t.index ["lead_id"], name: "index_quotations_on_lead_id"
  end

  create_table "refresh_tokens", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "token"
    t.uuid "user_id", null: false
    t.datetime "expire_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_refresh_tokens_on_token", unique: true
    t.index ["user_id"], name: "index_refresh_tokens_on_user_id"
  end

  create_table "rentals", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "code"
    t.date "start_date"
    t.date "end_date"
    t.string "status"
    t.datetime "delivery_date"
    t.datetime "return_date"
    t.text "vehicle_condition_delivery"
    t.text "vehicle_condition_return"
    t.decimal "total", precision: 12, scale: 2
    t.text "notes"
    t.uuid "quotation_id", null: false
    t.uuid "client_id", null: false
    t.uuid "vehicle_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_rentals_on_client_id"
    t.index ["code"], name: "index_rentals_on_code", unique: true
    t.index ["quotation_id"], name: "index_rentals_on_quotation_id"
    t.index ["vehicle_id"], name: "index_rentals_on_vehicle_id"
  end

  create_table "sales_orders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "code"
    t.string "status"
    t.decimal "total", precision: 12, scale: 2
    t.text "notes"
    t.uuid "quotation_id", null: false
    t.uuid "client_id", null: false
    t.uuid "advisor_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["advisor_id"], name: "index_sales_orders_on_advisor_id"
    t.index ["client_id"], name: "index_sales_orders_on_client_id"
    t.index ["code"], name: "index_sales_orders_on_code", unique: true
    t.index ["quotation_id"], name: "index_sales_orders_on_quotation_id"
  end

  create_table "spare_part_categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "spare_part_compatibilities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "spare_part_id", null: false
    t.uuid "vehicle_model_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["spare_part_id"], name: "index_spare_part_compatibilities_on_spare_part_id"
    t.index ["vehicle_model_id"], name: "index_spare_part_compatibilities_on_vehicle_model_id"
  end

  create_table "spare_part_specs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key"
    t.string "value"
    t.string "unit"
    t.uuid "spare_part_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["spare_part_id"], name: "index_spare_part_specs_on_spare_part_id"
  end

  create_table "spare_parts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "part_number"
    t.string "manufacturer_brand"
    t.integer "stock"
    t.integer "min_stock"
    t.string "sale_unit"
    t.boolean "is_critical"
    t.uuid "product_id", null: false
    t.uuid "spare_part_category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["part_number"], name: "index_spare_parts_on_part_number", unique: true
    t.index ["product_id"], name: "index_spare_parts_on_product_id"
    t.index ["spare_part_category_id"], name: "index_spare_parts_on_spare_part_category_id"
  end

  create_table "stock_movements", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "movement_type"
    t.integer "quantity"
    t.string "reference"
    t.uuid "performed_by_id", null: false
    t.uuid "spare_part_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["performed_by_id"], name: "index_stock_movements_on_performed_by_id"
    t.index ["spare_part_id"], name: "index_stock_movements_on_spare_part_id"
  end

  create_table "supplier_products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "supplier_code"
    t.decimal "unit_cost", precision: 12, scale: 2
    t.integer "lead_time_days"
    t.uuid "supplier_id", null: false
    t.uuid "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_supplier_products_on_product_id"
    t.index ["supplier_id"], name: "index_supplier_products_on_supplier_id"
  end

  create_table "suppliers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "code"
    t.string "business_name"
    t.string "document_type"
    t.string "document_number"
    t.string "contact_name"
    t.string "phone"
    t.string "email"
    t.text "address"
    t.string "city"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_suppliers_on_code", unique: true
    t.index ["document_number"], name: "index_suppliers_on_document_number", unique: true
  end

  create_table "technicians", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "full_name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "document_number", default: "", null: false
    t.string "document_type", default: "", null: false
    t.string "specialty"
    t.text "certification"
    t.string "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_number"], name: "index_technicians_on_document_number", unique: true
  end

  create_table "user_tracks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "os_data"
    t.string "remote_ip"
    t.string "browser_data"
    t.string "aud"
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_tracks_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "password_digest", default: "", null: false
    t.integer "status"
    t.string "avatar"
    t.string "phone"
    t.string "document_number", default: "", null: false
    t.string "roleable_type", null: false
    t.uuid "roleable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_number"], name: "index_users_on_document_number", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["phone"], name: "index_users_on_phone", unique: true
    t.index ["roleable_type", "roleable_id"], name: "index_users_on_roleable"
  end

  create_table "vehicle_model_specs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key"
    t.string "value"
    t.string "unit"
    t.uuid "vehicle_model_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["vehicle_model_id"], name: "index_vehicle_model_specs_on_vehicle_model_id"
  end

  create_table "vehicle_models", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "brand"
    t.string "model"
    t.decimal "power_hp", precision: 8, scale: 2
    t.decimal "weight_ton", precision: 8, scale: 2
    t.decimal "capacity_m3", precision: 8, scale: 2
    t.boolean "active"
    t.uuid "vehicle_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["vehicle_type_id"], name: "index_vehicle_models_on_vehicle_type_id"
  end

  create_table "vehicle_types", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vehicles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "product_id", null: false
    t.uuid "vehicle_model_id", null: false
    t.string "serial"
    t.integer "manufacture_year"
    t.decimal "hours_used", precision: 10, scale: 2
    t.string "status"
    t.decimal "price_per_hour", precision: 12, scale: 2
    t.decimal "price_per_day", precision: 12, scale: 2
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_vehicles_on_product_id"
    t.index ["serial"], name: "index_vehicles_on_serial", unique: true
    t.index ["vehicle_model_id"], name: "index_vehicles_on_vehicle_model_id"
  end

  create_table "warehousemen", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "full_name"
    t.string "email"
    t.string "document_number"
    t.string "document_type"
    t.string "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_number"], name: "index_warehousemen_on_document_number", unique: true
  end

  create_table "work_order_actions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "action"
    t.text "description"
    t.string "evidence"
    t.uuid "performed_by_id", null: false
    t.uuid "work_order_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["performed_by_id"], name: "index_work_order_actions_on_performed_by_id"
    t.index ["work_order_id"], name: "index_work_order_actions_on_work_order_id"
  end

  create_table "work_order_parts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "quantity"
    t.decimal "unit_price", precision: 12, scale: 2
    t.uuid "work_order_id", null: false
    t.uuid "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_work_order_parts_on_product_id"
    t.index ["work_order_id"], name: "index_work_order_parts_on_work_order_id"
  end

  create_table "work_orders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "code"
    t.text "diagnosis"
    t.string "diagnosis_result"
    t.string "work_order_type"
    t.string "status"
    t.datetime "scheduled_date"
    t.datetime "closed_date"
    t.uuid "maintenance_id", null: false
    t.uuid "assigned_to_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assigned_to_id"], name: "index_work_orders_on_assigned_to_id"
    t.index ["code"], name: "index_work_orders_on_code", unique: true
    t.index ["maintenance_id"], name: "index_work_orders_on_maintenance_id"
  end

  add_foreign_key "area_requests", "quotations"
  add_foreign_key "area_requests", "users", column: "created_by_id"
  add_foreign_key "area_requests", "users", column: "reviewed_by_id"
  add_foreign_key "blacklisted_tokens", "users"
  add_foreign_key "client_advisors", "advisors"
  add_foreign_key "client_advisors", "clients"
  add_foreign_key "client_contacts", "clients"
  add_foreign_key "customer_assets", "clients"
  add_foreign_key "delivery_guides", "dispatch_orders"
  add_foreign_key "delivery_guides", "logistics_users", column: "driver_id"
  add_foreign_key "delivery_guides", "vehicles"
  add_foreign_key "delivery_incidents", "delivery_guides"
  add_foreign_key "delivery_incidents", "users", column: "reported_by_id"
  add_foreign_key "dispatch_items", "dispatch_orders"
  add_foreign_key "dispatch_items", "products"
  add_foreign_key "dispatch_orders", "rentals"
  add_foreign_key "dispatch_orders", "sales_orders"
  add_foreign_key "dispatch_orders", "users", column: "prepared_by_id"
  add_foreign_key "lead_comments", "leads"
  add_foreign_key "lead_comments", "users"
  add_foreign_key "lead_status_histories", "leads"
  add_foreign_key "lead_status_histories", "users", column: "changed_by_id"
  add_foreign_key "leads", "advisors", column: "assigned_to_id"
  add_foreign_key "leads", "clients"
  add_foreign_key "maintenance_reports", "maintenances"
  add_foreign_key "maintenance_reports", "users", column: "created_by_id"
  add_foreign_key "maintenances", "clients"
  add_foreign_key "maintenances", "customer_assets"
  add_foreign_key "maintenances", "quotations"
  add_foreign_key "maintenances", "vehicles", column: "enterprise_vehicle_id"
  add_foreign_key "product_images", "products"
  add_foreign_key "products", "users", column: "created_by_id"
  add_foreign_key "products", "users", column: "updated_by_id"
  add_foreign_key "purchase_order_items", "products"
  add_foreign_key "purchase_order_items", "purchase_orders"
  add_foreign_key "purchase_orders", "suppliers"
  add_foreign_key "purchase_orders", "users", column: "requested_by_id"
  add_foreign_key "quotation_comments", "quotations"
  add_foreign_key "quotation_comments", "users"
  add_foreign_key "quotation_files", "quotations"
  add_foreign_key "quotation_items", "customer_assets"
  add_foreign_key "quotation_items", "products"
  add_foreign_key "quotation_items", "quotations"
  add_foreign_key "quotation_status_histories", "quotations"
  add_foreign_key "quotation_status_histories", "users", column: "changed_by_id"
  add_foreign_key "quotations", "advisors"
  add_foreign_key "quotations", "clients"
  add_foreign_key "quotations", "leads"
  add_foreign_key "refresh_tokens", "users"
  add_foreign_key "rentals", "clients"
  add_foreign_key "rentals", "quotations"
  add_foreign_key "rentals", "vehicles"
  add_foreign_key "sales_orders", "advisors"
  add_foreign_key "sales_orders", "clients"
  add_foreign_key "sales_orders", "quotations"
  add_foreign_key "spare_part_compatibilities", "spare_parts"
  add_foreign_key "spare_part_compatibilities", "vehicle_models"
  add_foreign_key "spare_part_specs", "spare_parts"
  add_foreign_key "spare_parts", "products"
  add_foreign_key "spare_parts", "spare_part_categories"
  add_foreign_key "stock_movements", "spare_parts"
  add_foreign_key "stock_movements", "users", column: "performed_by_id"
  add_foreign_key "supplier_products", "products"
  add_foreign_key "supplier_products", "suppliers"
  add_foreign_key "user_tracks", "users"
  add_foreign_key "vehicle_model_specs", "vehicle_models"
  add_foreign_key "vehicle_models", "vehicle_types"
  add_foreign_key "vehicles", "products"
  add_foreign_key "vehicles", "vehicle_models"
  add_foreign_key "work_order_actions", "technicians", column: "performed_by_id"
  add_foreign_key "work_order_actions", "work_orders"
  add_foreign_key "work_order_parts", "products"
  add_foreign_key "work_order_parts", "work_orders"
  add_foreign_key "work_orders", "maintenances"
  add_foreign_key "work_orders", "technicians", column: "assigned_to_id"
end
