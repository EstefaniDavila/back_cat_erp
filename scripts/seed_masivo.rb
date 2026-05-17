# =============================================================================
# SEED MASIVO - ERP CAT
# Uso: rails runner scripts/seed_masivo.rb
# =============================================================================
puts "\n🚀 SEED MASIVO INICIANDO..."
puts "=" * 60

def log(msg)   = puts("  ✅ #{msg}")
def warn_log(m)= puts("  ⚠️  #{m}")

ActiveRecord::Base.transaction do

# ── 1. ROLES / USUARIOS ──────────────────────────────────────
puts "\n📌 [1] Usuarios por rol (DNI = password)..."

unless Admin.exists?(document_number: "10000001")
  Admin.create!(first_name: "Carlos", last_name: "Admin", full_name: "Carlos Admin",
    email: "admin@erpcat.com", document_number: "10000001", document_type: "DNI")
  log "Admin → admin@erpcat.com / 10000001"
else; warn_log "Admin ya existe"; end

unless Manager.exists?(document_number: "10000002")
  Manager.create!(first_name: "Maria", last_name: "Gerente", full_name: "Maria Gerente",
    email: "manager@erpcat.com", document_number: "10000002", document_type: "DNI", area: "Comercial")
  log "Manager → manager@erpcat.com / 10000002"
else; warn_log "Manager ya existe"; end

unless Manager.exists?(document_number: "10000012")
  Manager.create!(first_name: "Juan", last_name: "Gerente", full_name: "Juan Gerente",
    email: "operationmanager@erpcat.com", document_number: "10000012", document_type: "DNI", area: "Operations")
  log "Manager → operationmanager@erpcat.com / 100000012"
else; warn_log "Manager ya existe"; end

unless Advisor.exists?(document_number: "10000003")
  Advisor.create!(first_name: "Luis", last_name: "Asesor", full_name: "Luis Asesor",
    email: "advisor@erpcat.com", document_number: "10000003", document_type: "DNI",
    code: "ADV-001", phone: "999000003", commission_rate: 5.0, status: "active")
  log "Advisor → advisor@erpcat.com / 10000003"
else; warn_log "Advisor ya existe"; end

unless Technician.exists?(document_number: "10000004")
  Technician.create!(first_name: "Pedro", last_name: "Tecnico", full_name: "Pedro Tecnico",
    email: "technician@erpcat.com", document_number: "10000004", document_type: "DNI",
    specialty: "Maquinaria pesada", certification: "ISO 9001", status: "active")
  log "Technician → technician@erpcat.com / 10000004"
else; warn_log "Technician ya existe"; end

unless LogisticsUser.exists?(document_number: "10000005")
  LogisticsUser.create!(first_name: "Ana", last_name: "Logistica", full_name: "Ana Logistica",
    email: "logistics@erpcat.com", document_number: "10000005", document_type: "DNI", position: "Conductor")
  log "LogisticsUser → logistics@erpcat.com / 10000005"
else; warn_log "LogisticsUser ya existe"; end

unless Warehouseman.exists?(document_number: "10000006")
  wm = Warehouseman.create!(first_name: "Jorge", last_name: "Almacen", full_name: "Jorge Almacen",
    email: "warehouse@erpcat.com", document_number: "10000006", document_type: "DNI", position: "Jefe Almacen")
  User.create!(email: "warehouse@erpcat.com", document_number: "10000006",
    password: "10000006", password_confirmation: "10000006", roleable: wm) unless User.exists?(document_number: "10000006")
  log "Warehouseman → warehouse@erpcat.com / 10000006"
else; warn_log "Warehouseman ya existe"; end

unless Client.exists?(document_number: "10000007")
  cl = Client.create!(business_name: "Cliente Demo SAC", document_number: "10000007",
    document_type: "DNI", email: "cliente@erpcat.com", contact_name: "Roberto Cliente",
    phone: "999000007", status: "active")
  User.create!(email: "cliente@erpcat.com", document_number: "10000007",
    password: "10000007", password_confirmation: "10000007", roleable: cl) unless User.exists?(document_number: "10000007")
  log "Client → cliente@erpcat.com / 10000007"
else; warn_log "Client ya existe"; end

# ── 2. VEHICLE TYPES ─────────────────────────────────────────
puts "\n📌 [2] Tipos de vehículo..."
vtype_data = [
  ["Excavadora", "Maquinaria de excavacion pesada"],
  ["Volquete", "Camion volquete para transporte"],
  ["Cargador", "Cargador frontal de ruedas"],
  ["Motoniveladora", "Maquina para nivelar terrenos"],
  ["Retroexcavadora", "Retroexcavadora combinada"]
]
vtypes = vtype_data.map { |n, d| VehicleType.find_or_create_by!(name: n) { |v| v.description = d } }
log "#{vtypes.size} tipos listos"

# ── 3. VEHICLE MODELS ────────────────────────────────────────
puts "\n📌 [3] Modelos de vehículo..."
vmodel_data = [
  ["Caterpillar","320GC", 158, 20.5, 1.2,  0],
  ["Komatsu",    "PC210", 162, 21.0, 1.0,  0],
  ["Volvo",      "A40G",  420, 39.0, 24.0, 1],
  ["Caterpillar","777G",  1050,95.0, 55.0, 1],
  ["John Deere", "744L",  252, 20.2, 3.8,  2],
  ["Caterpillar","120K2", 148, 14.1, 0.0,  3],
  ["Komatsu",    "GD555", 155, 14.7, 0.0,  3],
  ["JCB",        "3CX",   74,  8.4,  0.28, 4],
]
vmodels = vmodel_data.map do |brand, model, hp, wt, cap, ti|
  VehicleModel.find_or_create_by!(brand: brand, model: model) do |m|
    m.power_hp = hp; m.weight_ton = wt; m.capacity_m3 = cap
    m.active = true; m.vehicle_type = vtypes[ti]
  end
end
log "#{vmodels.size} modelos listos"

# ── 4. VEHICLE MODEL SPECS ───────────────────────────────────
puts "\n📌 [4] Specs de modelos..."
vmodels.each_with_index do |vm, i|
  next if VehicleModelSpec.exists?(vehicle_model: vm)
  VehicleModelSpec.create!(vehicle_model: vm, key: "Potencia", value: vm.power_hp.to_s, unit: "HP")
  VehicleModelSpec.create!(vehicle_model: vm, key: "Peso", value: vm.weight_ton.to_s, unit: "Ton")
end
log "Specs creados"

# ── 5. SPARE PART CATEGORIES ─────────────────────────────────
puts "\n📌 [5] Categorías de repuestos..."
cat_names = ["Motor","Hidraulico","Transmision","Electrico","Filtros","Frenos","Estructura","Neumaticos"]
spare_cats = cat_names.map { |n| SparePartCategory.find_or_create_by!(name: n) { |c| c.description = "Cat: #{n}" } }
log "#{spare_cats.size} categorías listas"

# ── 6. PRODUCTS: VEHICULOS ───────────────────────────────────
puts "\n📌 [6] Productos - Vehículos..."
admin_user = User.joins("JOIN admins ON users.roleable_id = admins.id AND users.roleable_type = 'Admin'").first

if admin_user
  veh_data = [
    ["Excavadora CAT 320GC 2022",    "Excavadora 20t",   350000, 0, "SRL-320GC-001"],
    ["Excavadora Komatsu PC210 2021", "Excavadora 21t",   320000, 1, "SRL-PC210-001"],
    ["Volquete Volvo A40G 2023",      "Volquete 39t",     450000, 2, "SRL-A40G-001"],
    ["Volquete CAT 777G 2020",        "Camion 95t",       980000, 3, "SRL-777G-001"],
    ["Cargador JD 744L 2022",         "Cargador 3.8m3",   280000, 4, "SRL-744L-001"],
    ["Motoniveladora CAT 120K2 2021", "Moto 148HP",       210000, 5, "SRL-120K2-001"],
    ["Motoniveladora Komatsu GD555",  "Moto 155HP",       225000, 6, "SRL-GD555-001"],
    ["Retroexcavadora JCB 3CX 2023",  "Retro combinada",   95000, 7, "SRL-3CX-001"],
  ]
  created = 0
  veh_data.each_with_index do |(name, desc, price, mi, serial), i|
    next if Vehicle.exists?(serial: serial)
    Product.create!(product_type: "vehicle", name: name, description: desc,
      base_price: price, active: true, created_by: admin_user, updated_by: admin_user,
      vehicle_attributes: {
        vehicle_model_id: vmodels[mi].id, serial: serial,
        manufacture_year: 2020 + (i % 4), hours_used: rand(100..4000).to_f,
        status: "available", price_per_hour: price / 5000.0,
        price_per_day: price / 300.0, location: ["Lima","Arequipa","Cusco","Trujillo"].sample
      })
    created += 1
  rescue => e; warn_log "Veh #{name}: #{e.message}"
  end
  log "#{created} vehículos creados"

  # ── 7. PRODUCTS: REPUESTOS ─────────────────────────────────
  puts "\n📌 [7] Productos - Repuestos..."
  sp_data = [
    ["Filtro aceite CAT",  "FLT-OIL-001","Caterpillar",85,   50,10,4],
    ["Filtro hidraulico",  "FLT-HYD-001","Komatsu",    120,  30, 5,4],
    ["Bomba hidraulica",   "BOM-HYD-001","Parker",     3500,  8, 2,1],
    ["Manguera hidraulica","MNG-HYD-001","Gates",      250,  40,10,1],
    ["Correa alternador",  "COR-ALT-001","Gates",       95,  25, 5,0],
    ["Bateria 12V 200Ah",  "BAT-12V-001","Bosch",      450,  15, 3,3],
    ["Pastillas de freno", "PAS-FRN-001","Brembo",     320,  20, 5,5],
    ["Neumatico 23.5R25",  "NEU-235-001","Bridgestone",4500, 12, 2,7],
    ["Aceite motor 15W40", "ACE-MOT-001","Mobil",      280,  60,15,0],
    ["Kit de sellos",      "KIT-SEL-001","Parker",     180,  35, 8,1],
  ]
  created = 0
  sp_data.each do |name, part, brand, price, stock, min, ci|
    next if SparePart.exists?(part_number: part)
    Product.create!(product_type: "spare_part", name: name,
      description: "Repuesto #{brand} - #{name}", base_price: price,
      active: true, created_by: admin_user, updated_by: admin_user,
      spare_part_attributes: {
        part_number: part, manufacturer_brand: brand, stock: stock,
        min_stock: min, sale_unit: "unidad", is_critical: stock <= min * 2,
        spare_part_category_id: spare_cats[ci].id
      })
    created += 1
  rescue => e; warn_log "SP #{name}: #{e.message}"
  end
  log "#{created} repuestos creados"
else
  warn_log "No hay admin_user, saltando productos"
end

# ── 8. SPARE PART SPECS & COMPATIBILIDADES ───────────────────
puts "\n📌 [8] Specs y compatibilidades de repuestos..."
SparePart.all.each do |sp|
  next if SparePartSpec.exists?(spare_part: sp)
  SparePartSpec.create!(spare_part: sp, key: "Marca", value: sp.manufacturer_brand.to_s, unit: "")
  SparePartSpec.create!(spare_part: sp, key: "Stock", value: sp.stock.to_s, unit: "unidades")
end
SparePart.limit(4).each_with_index do |sp, i|
  vm = vmodels[i]
  next unless vm
  next if SparePartCompatibility.exists?(spare_part: sp, vehicle_model: vm)
  SparePartCompatibility.create!(spare_part: sp, vehicle_model: vm)
rescue => e; warn_log "Compat: #{e.message}"
end
log "Specs y compatibilidades listas"

# ── 9. SUPPLIERS ─────────────────────────────────────────────
puts "\n📌 [9] Proveedores..."
sup_data = [
  ["SUP-001","Caterpillar Peru SA",  "20512345671","Juan Prov",   "01-2345678","ventas@catperu.com",  "Lima"],
  ["SUP-002","Komatsu Mitsui SA",    "20512345672","Maria Dist",  "01-3456789","ventas@komatsu.pe",   "Lima"],
  ["SUP-003","Ferreyros SAA",        "20512345673","Carlos Fe",   "01-4567890","compras@ferreyros.com","Lima"],
  ["SUP-004","Parker Hannifin Peru", "20512345674","Ana Parker",  "01-5678901","ventas@parker.pe",    "Lima"],
  ["SUP-005","Hidrostal SA",         "20512345675","Luis Hidro",  "044-234567","ventas@hidrostal.com","Trujillo"],
]
suppliers = []
sup_data.each do |code, name, ruc, contact, phone, email, city|
  s = Supplier.find_or_initialize_by(document_number: ruc)
  if s.new_record?
    s.update!(code: code, business_name: name, document_type: "RUC",
      contact_name: contact, phone: phone, email: email,
      address: "Av. Industrial #{rand(100..999)}", city: city, status: "active")
  end
  suppliers << s
rescue => e; warn_log "Sup #{name}: #{e.message}"
end
log "#{suppliers.size} proveedores listos"

# ── 10. SUPPLIER PRODUCTS ────────────────────────────────────
puts "\n📌 [10] Productos por proveedor..."
spare_products = Product.where(product_type: "spare_part").to_a
created = 0
spare_products.first(5).each_with_index do |p, i|
  sup = suppliers[i % suppliers.size]
  next unless sup
  next if SupplierProduct.exists?(supplier: sup, product: p)
  SupplierProduct.create!(supplier: sup, product: p,
    supplier_code: "#{sup.code}-#{i+1}", unit_cost: p.base_price * 0.7, lead_time_days: rand(5..30))
  created += 1
rescue => e; warn_log "SupProd: #{e.message}"
end
log "#{created} supplier_products creados"

# ── 11. CLIENTS (masivos) ────────────────────────────────────
puts "\n📌 [11] Clientes masivos..."
companies = [
  ["Minera Los Andes SAC",     "20510000011"],
  ["Construcciones Pacifico",  "20510000012"],
  ["Grupo Constructor Andino", "20510000013"],
  ["Inversiones Sur SRL",      "20510000014"],
  ["Trans Cargo Norte SA",     "20510000015"],
  ["Agregados Materiales SAC", "20510000016"],
  ["Empresa Minera Horizonte", "20510000017"],
  ["Constructora Sigma SAC",   "20510000018"],
  ["Servicios Integrales JM",  "20510000019"],
  ["Minera San Cristobal SA",  "20510000020"],
]
clients = []
companies.each_with_index do |(name, ruc), i|
  cl = Client.find_or_initialize_by(document_number: ruc)
  if cl.new_record?
    cl.update!(business_name: name, document_type: "RUC",
      contact_name: "Contacto #{i+1}", phone: "01-#{rand(1000000..9999999)}",
      email: "contacto#{i+1}@empresa#{i+1}.com",
      address: "Av. Empresarial #{rand(100..999)}, Lima",
      city: ["Lima","Arequipa","Cusco","Trujillo"].sample,
      status: "active", client_category: ["A","B","C"].sample,
      first_contact_date: rand(1..365).days.ago.to_date)
  end
  clients << cl
rescue => e; warn_log "Client #{name}: #{e.message}"
end
log "#{clients.size} clientes listos"

# ── 12. CLIENT CONTACTS ──────────────────────────────────────
puts "\n📌 [12] Contactos de clientes..."
created = 0
clients.first(5).each do |cl|
  next if ClientContact.exists?(client: cl)
  ClientContact.create!(client: cl, name: "Contacto Principal #{cl.code}",
    position: "Gerente", phone: "9#{rand(10000000..99999999)}", email: cl.email, is_primary: true)
  created += 1
rescue => e; warn_log "Contact: #{e.message}"
end
log "#{created} contactos creados"

# ── 13. CUSTOMER ASSETS ──────────────────────────────────────
puts "\n📌 [13] Activos de clientes..."
asset_types = ["excavadora","camion","compresora","generador","grua"]
created = 0
clients.first(5).each_with_index do |cl, i|
  next if CustomerAsset.exists?(client: cl)
  CustomerAsset.create!(client: cl, asset_type: asset_types[i % 5],
    name: "#{asset_types[i%5].capitalize} #{cl.code}",
    brand: ["CAT","Komatsu","Volvo"].sample, asset_model: "Modelo-#{i+1}",
    serial_number: "SN-#{SecureRandom.hex(4).upcase}", year: 2018 + (i % 6),
    description: "Activo de #{cl.business_name}", status: "active")
  created += 1
rescue => e; warn_log "Asset: #{e.message}"
end
log "#{created} activos creados"

end # transaction

puts "\n" + "=" * 60
puts "✅ PARTE 1 COMPLETA - continuando con seed_masivo_2.rb"
puts "📊 Estado actual:"
puts "   Users: #{User.count} | Clients: #{Client.count} | Products: #{Product.count}"
puts "   Suppliers: #{Supplier.count} | VehicleModels: #{VehicleModel.count}"
puts "=" * 60
