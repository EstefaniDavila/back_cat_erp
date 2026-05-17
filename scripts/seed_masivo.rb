# =============================================================================
# SCRIPT DE SEED MASIVO - ERP CAT
# Uso: rails runner scripts/seed_masivo.rb
# Crea un usuario por rol (DNI = password), + datos masivos
# =============================================================================

puts "\n🚀 INICIANDO SEED MASIVO..."
puts "=" * 60

# ─────────────────────────────────────────────────────────────
# HELPERS
# ─────────────────────────────────────────────────────────────
def log(msg)
  puts "  ✅ #{msg}"
end

def warn_log(msg)
  puts "  ⚠️  #{msg}"
end

# ─────────────────────────────────────────────────────────────
# 1. USUARIOS POR ROL (DNI = password)
# ─────────────────────────────────────────────────────────────
puts "\n📌 [1/9] Creando usuarios por rol..."

# ADMIN
unless Admin.exists?(document_number: "10000001")
  Admin.create!(
    first_name: "Carlos",
    last_name:  "Administrador",
    full_name:  "Carlos Administrador",
    email:      "admin@erpcat.com",
    document_number: "10000001",
    document_type:   "DNI"
  )
  log "Admin creado  → DNI: 10000001 | Email: admin@erpcat.com | Password: 10000001"
else
  warn_log "Admin ya existe"
end

# MANAGER
unless Manager.exists?(document_number: "10000002")
  Manager.create!(
    first_name: "María",
    last_name:  "Gerente",
    full_name:  "María Gerente",
    email:      "manager@erpcat.com",
    document_number: "10000002",
    document_type:   "DNI",
    area:            "Comercial"
  )
  log "Manager creado → DNI: 10000002 | Email: manager@erpcat.com | Password: 10000002"
else
  warn_log "Manager ya existe"
end

# ADVISOR
unless Advisor.exists?(document_number: "10000003")
  Advisor.create!(
    first_name:      "Luis",
    last_name:       "Asesor",
    full_name:       "Luis Asesor",
    email:           "advisor@erpcat.com",
    document_number: "10000003",
    document_type:   "DNI",
    code:            "ADV-001",
    phone:           "999000003",
    commission_rate: 5.0,
    status:          "active"
  )
  log "Advisor creado → DNI: 10000003 | Email: advisor@erpcat.com | Password: 10000003"
else
  warn_log "Advisor ya existe"
end

# TECHNICIAN
unless Technician.exists?(document_number: "10000004")
  Technician.create!(
    first_name:      "Pedro",
    last_name:       "Técnico",
    full_name:       "Pedro Técnico",
    email:           "technician@erpcat.com",
    document_number: "10000004",
    document_type:   "DNI",
    specialty:       "Maquinaria pesada",
    certification:   "ISO 9001",
    status:          "active"
  )
  log "Technician creado → DNI: 10000004 | Email: technician@erpcat.com | Password: 10000004"
else
  warn_log "Technician ya existe"
end

# LOGISTICS USER
unless LogisticsUser.exists?(document_number: "10000005")
  LogisticsUser.create!(
    first_name:      "Ana",
    last_name:       "Logística",
    full_name:       "Ana Logística",
    email:           "logistics@erpcat.com",
    document_number: "10000005",
    document_type:   "DNI",
    position:        "Conductor"
  )
  log "LogisticsUser creado → DNI: 10000005 | Email: logistics@erpcat.com | Password: 10000005"
else
  warn_log "LogisticsUser ya existe"
end

# WAREHOUSEMAN
unless Warehouseman.exists?(document_number: "10000006")
  wm = Warehouseman.create!(
    first_name:      "Jorge",
    last_name:       "Almacén",
    full_name:       "Jorge Almacén",
    email:           "warehouse@erpcat.com",
    document_number: "10000006",
    document_type:   "DNI",
    position:        "Jefe de Almacén"
  )
  # Warehouseman no tiene after_create :generate_user, crearlo manualmente
  unless User.exists?(document_number: "10000006")
    User.create!(
      email:            "warehouse@erpcat.com",
      document_number:  "10000006",
      password:         "10000006",
      password_confirmation: "10000006",
      roleable: wm
    )
  end
  log "Warehouseman creado → DNI: 10000006 | Email: warehouse@erpcat.com | Password: 10000006"
else
  warn_log "Warehouseman ya existe"
end

# CLIENT (vía registro normal, crea user automático)
unless Client.exists?(document_number: "10000007")
  client_user = Client.create!(
    business_name:   "Cliente Demo S.A.C.",
    document_number: "10000007",
    document_type:   "DNI",
    email:           "cliente@erpcat.com",
    contact_name:    "Roberto Cliente",
    phone:           "999000007",
    status:          "active"
  )
  unless User.exists?(document_number: "10000007")
    User.create!(
      email:            "cliente@erpcat.com",
      document_number:  "10000007",
      password:         "10000007",
      password_confirmation: "10000007",
      roleable: client_user
    )
  end
  log "Client creado → DNI: 10000007 | Email: cliente@erpcat.com | Password: 10000007"
else
  warn_log "Client ya existe"
end

# ─────────────────────────────────────────────────────────────
# 2. VEHICLE TYPES & MODELS
# ─────────────────────────────────────────────────────────────
puts "\n📌 [2/9] Creando tipos y modelos de vehículos..."

vehicle_types_data = [
  { name: "Excavadora",    description: "Maquinaria de excavación pesada" },
  { name: "Volquete",      description: "Camión volquete para transporte de material" },
  { name: "Cargador",      description: "Cargador frontal de ruedas" },
  { name: "Motoniveladora",description: "Máquina para nivelar terrenos" },
  { name: "Retroexcavadora", description: "Retroexcavadora combinada" }
]

vtypes = vehicle_types_data.map do |vt|
  VehicleType.find_or_create_by!(name: vt[:name]) { |v| v.description = vt[:description] }
end
log "#{vtypes.size} tipos de vehículo listos"

vehicle_models_data = [
  { brand: "Caterpillar", model: "320GC",   power_hp: 158, weight_ton: 20.5, capacity_m3: 1.2,  active: true, type_idx: 0 },
  { brand: "Komatsu",     model: "PC210",   power_hp: 162, weight_ton: 21.0, capacity_m3: 1.0,  active: true, type_idx: 0 },
  { brand: "Volvo",       model: "A40G",    power_hp: 420, weight_ton: 39.0, capacity_m3: 24.0, active: true, type_idx: 1 },
  { brand: "Caterpillar", model: "777G",    power_hp: 1050,weight_ton: 95.0, capacity_m3: 55.0, active: true, type_idx: 1 },
  { brand: "John Deere",  model: "744L",    power_hp: 252, weight_ton: 20.2, capacity_m3: 3.8,  active: true, type_idx: 2 },
  { brand: "Caterpillar", model: "120K2",   power_hp: 148, weight_ton: 14.1, capacity_m3: 0.0,  active: true, type_idx: 3 },
  { brand: "Komatsu",     model: "GD555-5", power_hp: 155, weight_ton: 14.7, capacity_m3: 0.0,  active: true, type_idx: 3 },
  { brand: "JCB",         model: "3CX",     power_hp: 74,  weight_ton: 8.4,  capacity_m3: 0.28, active: true, type_idx: 4 },
]

vmodels = vehicle_models_data.map do |vm|
  VehicleModel.find_or_create_by!(brand: vm[:brand], model: vm[:model]) do |m|
    m.power_hp       = vm[:power_hp]
    m.weight_ton     = vm[:weight_ton]
    m.capacity_m3    = vm[:capacity_m3]
    m.active         = vm[:active]
    m.vehicle_type   = vtypes[vm[:type_idx]]
  end
end
log "#{vmodels.size} modelos de vehículo listos"

# ─────────────────────────────────────────────────────────────
# 3. SPARE PART CATEGORIES
# ─────────────────────────────────────────────────────────────
puts "\n📌 [3/9] Creando categorías de repuestos..."

cat_names = ["Motor", "Hidráulico", "Transmisión", "Eléctrico", "Filtros", "Frenos", "Estructura", "Neumáticos"]
spare_cats = cat_names.map do |name|
  SparePartCategory.find_or_create_by!(name: name) { |c| c.description = "Categoría: #{name}" }
end
log "#{spare_cats.size} categorías de repuestos listas"

# ─────────────────────────────────────────────────────────────
# 4. PRODUCTS - VEHICLES & SPARE PARTS
# ─────────────────────────────────────────────────────────────
puts "\n📌 [4/9] Creando productos (vehículos y repuestos)..."

admin_user = User.joins("JOIN admins ON users.roleable_id = admins.id AND users.roleable_type = 'Admin'")
                 .first

if admin_user.nil?
  puts "  ❌ No se encontró usuario Admin. Saltando productos..."
else
  # Vehículos
  vehicle_products_data = [
    { name: "Excavadora CAT 320GC - 2022",   desc: "Excavadora de orugas 20 ton",  price: 350000, model_idx: 0 },
    { name: "Excavadora Komatsu PC210 - 2021",desc: "Excavadora hidráulica 21 ton", price: 320000, model_idx: 1 },
    { name: "Volquete Volvo A40G - 2023",     desc: "Volquete articulado 39 ton",   price: 450000, model_idx: 2 },
    { name: "Volquete CAT 777G - 2020",       desc: "Camión minero 95 ton",         price: 980000, model_idx: 3 },
    { name: "Cargador John Deere 744L - 2022",desc: "Cargador frontal 3.8m3",       price: 280000, model_idx: 4 },
    { name: "Motoniveladora CAT 120K2 - 2021",desc: "Motoniveladora 148HP",         price: 210000, model_idx: 5 },
    { name: "Motoniveladora Komatsu GD555 - 2022",desc: "Motoniveladora 155HP",     price: 225000, model_idx: 6 },
    { name: "Retroexcavadora JCB 3CX - 2023", desc: "Retroexcavadora combinada",    price: 95000,  model_idx: 7 },
  ]

  serials = ["SRL-320GC-001", "SRL-PC210-001", "SRL-A40G-001", "SRL-777G-001",
             "SRL-744L-001", "SRL-120K2-001", "SRL-GD555-001", "SRL-3CX-001"]

  created_veh = 0
  vehicle_products_data.each_with_index do |vp, i|
    next if Vehicle.exists?(serial: serials[i])
    product = Product.create!(
      product_type: "vehicle",
      name:         vp[:name],
      description:  vp[:desc],
      base_price:   vp[:price],
      active:       true,
      created_by:   admin_user,
      updated_by:   admin_user
    )
    product.vehicle.update!(
      vehicle_model: vmodels[vp[:model_idx]],
      serial:        serials[i],
      manufacture_year: 2021 + (i % 3),
      hours_used:    rand(100..5000).to_f,
      status:        "available",
      price_per_hour: vp[:price] / 5000.0,
      price_per_day:  vp[:price] / 500.0,
      location:      ["Lima", "Arequipa", "Cusco", "Trujillo"].sample
    )
    created_veh += 1
  rescue => e
    warn_log "Vehicle #{vp[:name]}: #{e.message}"
  end
  log "#{created_veh} vehículos creados"

  # Repuestos
  spare_parts_data = [
    { name: "Filtro de aceite CAT", part: "FLT-OIL-001", brand: "Caterpillar", price: 85,   stock: 50, min: 10, cat_idx: 4 },
    { name: "Filtro hidráulico",    part: "FLT-HYD-001", brand: "Komatsu",     price: 120,  stock: 30, min: 5,  cat_idx: 4 },
    { name: "Bomba hidráulica",     part: "BOM-HYD-001", brand: "Parker",      price: 3500, stock: 8,  min: 2,  cat_idx: 1 },
    { name: "Manguera hidráulica",  part: "MNG-HYD-001", brand: "Gates",       price: 250,  stock: 40, min: 10, cat_idx: 1 },
    { name: "Correa de alternador", part: "COR-ALT-001", brand: "Gates",       price: 95,   stock: 25, min: 5,  cat_idx: 0 },
    { name: "Batería 12V 200Ah",    part: "BAT-12V-001", brand: "Bosch",       price: 450,  stock: 15, min: 3,  cat_idx: 3 },
    { name: "Pastillas de freno",   part: "PAS-FRN-001", brand: "Brembo",      price: 320,  stock: 20, min: 5,  cat_idx: 5 },
    { name: "Neumático 23.5R25",    part: "NEU-235-001", brand: "Bridgestone", price: 4500, stock: 12, min: 2,  cat_idx: 7 },
    { name: "Aceite motor 15W40",   part: "ACE-MOT-001", brand: "Mobil",       price: 280,  stock: 60, min: 15, cat_idx: 0 },
    { name: "Kit de sellos",        part: "KIT-SEL-001", brand: "Parker",      price: 180,  stock: 35, min: 8,  cat_idx: 1 },
  ]

  created_sp = 0
  spare_parts_data.each do |sp|
    next if SparePart.exists?(part_number: sp[:part])
    product = Product.create!(
      product_type: "spare_part",
      name:         sp[:name],
      description:  "Repuesto original #{sp[:brand]} - #{sp[:name]}",
      base_price:   sp[:price],
      active:       true,
      created_by:   admin_user,
      updated_by:   admin_user
    )
    product.spare_part.update!(
      part_number:          sp[:part],
      manufacturer_brand:   sp[:brand],
      stock:                sp[:stock],
      min_stock:            sp[:min],
      sale_unit:            "unidad",
      is_critical:          sp[:stock] <= sp[:min] * 2,
      spare_part_category:  spare_cats[sp[:cat_idx]]
    )
    created_sp += 1
  rescue => e
    warn_log "SparePart #{sp[:name]}: #{e.message}"
  end
  log "#{created_sp} repuestos creados"
end

# ─────────────────────────────────────────────────────────────
# 5. SUPPLIERS
# ─────────────────────────────────────────────────────────────
puts "\n📌 [5/9] Creando proveedores..."

suppliers_data = [
  { code: "SUP-001", name: "Caterpillar Perú S.A.", ruc: "20512345671", contact: "Juan Proveedor", phone: "01-2345678", email: "ventas@catperu.com", city: "Lima" },
  { code: "SUP-002", name: "Komatsu Mitsui S.A.",   ruc: "20512345672", contact: "María Distribuidora", phone: "01-3456789", email: "ventas@komatsu.pe", city: "Lima" },
  { code: "SUP-003", name: "Ferreyros S.A.A.",       ruc: "20512345673", contact: "Carlos Ferreyros", phone: "01-4567890", email: "compras@ferreyros.com", city: "Lima" },
  { code: "SUP-004", name: "Parker Hannifin Perú",   ruc: "20512345674", contact: "Ana Parker", phone: "01-5678901", email: "ventas@parker.pe", city: "Lima" },
  { code: "SUP-005", name: "Hidrostal S.A.",         ruc: "20512345675", contact: "Luis Hidrostal", phone: "044-234567", email: "ventas@hidrostal.com", city: "Trujillo" },
]

created_sup = 0
suppliers_data.each do |s|
  next if Supplier.exists?(document_number: s[:ruc])
  Supplier.create!(
    code:            s[:code],
    business_name:   s[:name],
    document_type:   "RUC",
    document_number: s[:ruc],
    contact_name:    s[:contact],
    phone:           s[:phone],
    email:           s[:email],
    address:         "Av. Industrial #{rand(100..999)}",
    city:            s[:city],
    status:          "active"
  )
  created_sup += 1
rescue => e
  warn_log "Supplier #{s[:name]}: #{e.message}"
end
log "#{created_sup} proveedores creados"

# ─────────────────────────────────────────────────────────────
# 6. CLIENTS (masivos)
# ─────────────────────────────────────────────────────────────
puts "\n📌 [6/9] Creando clientes masivos..."

company_names = [
  "Minera Los Andes S.A.C.", "Construcciones Pacífico S.A.", "Grupo Constructor Andino",
  "Inversiones Sur S.R.L.", "Trans Cargo Norte S.A.", "Agregados y Materiales SAC",
  "Empresa Minera Horizonte", "Constructora Sigma S.A.C.", "Servicios Integrales JM",
  "Minera San Cristóbal S.A.", "Concesionaria Vial Andina", "Ingeniería y Proyectos Lima"
]

created_cli = 0
company_names.each_with_index do |name, i|
  doc = "2051000#{(i + 10).to_s.rjust(4, '0')}"
  next if Client.exists?(document_number: doc)
  Client.create!(
    business_name:    name,
    document_type:    "RUC",
    document_number:  doc,
    contact_name:     "Contacto #{i + 1}",
    phone:            "01-#{rand(1000000..9999999)}",
    email:            "contacto#{i + 1}@empresa#{i + 1}.com",
    address:          "Av. Empresarial #{rand(100..999)}, Lima",
    city:             ["Lima", "Arequipa", "Cusco", "Trujillo", "Piura"].sample,
    status:           "active",
    client_category:  ["A", "B", "C"].sample,
    first_contact_date: rand(1..365).days.ago.to_date
  )
  created_cli += 1
rescue => e
  warn_log "Client #{name}: #{e.message}"
end
log "#{created_cli} clientes creados"

# ─────────────────────────────────────────────────────────────
# 7. LEADS
# ─────────────────────────────────────────────────────────────
puts "\n📌 [7/9] Creando leads..."

advisor = Advisor.first
clients = Client.limit(10).to_a

lead_statuses   = %w[new contacted qualified proposal negotiation closed_won closed_lost]
lead_priorities = %w[low medium high urgent]
lead_sources    = %w[web referral cold_call social_media event]
lead_types      = %w[sale rental maintenance spare_parts]

created_leads = 0
10.times do |i|
  client = clients[i % clients.size]
  next unless advisor && client
  begin
    Lead.create!(
      name:          "Lead #{i + 1} - #{client.business_name}",
      email:         "lead#{i + 1}@mail.com",
      phone:         "9#{rand(10000000..99999999)}",
      source:        lead_sources.sample,
      lead_type:     lead_types.sample,
      status:        lead_statuses.sample,
      priority:      lead_priorities.sample,
      notes:         "Interesado en alquiler de maquinaria pesada para proyecto en zona sur.",
      assigned_to:   advisor,
      client:        client
    )
    created_leads += 1
  rescue => e
    warn_log "Lead #{i + 1}: #{e.message}"
  end
end
log "#{created_leads} leads creados"

# ─────────────────────────────────────────────────────────────
# 8. QUOTATIONS
# ─────────────────────────────────────────────────────────────
puts "\n📌 [8/9] Creando cotizaciones..."

advisor     = Advisor.first
clients     = Client.limit(8).to_a
products    = Product.where(product_type: "vehicle").limit(5).to_a
q_types     = %w[sale rental spare_parts maintenance]
q_statuses  = %w[draft sent approved rejected]

created_q = 0
8.times do |i|
  client  = clients[i % clients.size]
  product = products[i % products.size]
  next unless advisor && client && product

  begin
    q = Quotation.create!(
      quotation_type: q_types[i % q_types.size],
      status:         q_statuses[i % q_statuses.size],
      subtotal:       product.base_price,
      tax:            (product.base_price * 0.18).round(2),
      total:          (product.base_price * 1.18).round(2),
      valid_until:    30.days.from_now.to_date,
      client:         client,
      advisor:        advisor
    )
    # Agregar item
    QuotationItem.create!(
      description:   product.name,
      quantity:      1,
      unit_price:    product.base_price,
      total_price:   product.base_price,
      item_type:     q.quotation_type,
      quotation:     q,
      product:       product
    )
    created_q += 1
  rescue => e
    warn_log "Quotation #{i + 1}: #{e.message}"
  end
end
log "#{created_q} cotizaciones creadas"

# ─────────────────────────────────────────────────────────────
# 9. MAINTENANCES
# ─────────────────────────────────────────────────────────────
puts "\n📌 [9/9] Creando mantenimientos..."

clients   = Client.limit(5).to_a
mnt_types = %w[preventive corrective]
mnt_stats = %w[pending in_progress completed]
priorities= %w[low medium high]

created_mnt = 0
5.times do |i|
  client = clients[i % clients.size]
  next unless client
  begin
    Maintenance.create!(
      description:      "Mantenimiento #{mnt_types[i % 2]} - Unidad #{i + 1}",
      maintenance_type: mnt_types[i % 2],
      priority:         priorities[i % 3],
      status:           mnt_stats[i % 3],
      requested_at:     rand(1..30).days.ago,
      client:           client
    )
    created_mnt += 1
  rescue => e
    warn_log "Maintenance #{i + 1}: #{e.message}"
  end
end
log "#{created_mnt} mantenimientos creados"

# ─────────────────────────────────────────────────────────────
# RESUMEN FINAL
# ─────────────────────────────────────────────────────────────
puts "\n" + "=" * 60
puts "✅ SEED COMPLETADO"
puts "=" * 60
puts ""
puts "👤 USUARIOS CREADOS (DNI = Password):"
puts "   Admin       → admin@erpcat.com        / 10000001"
puts "   Manager     → manager@erpcat.com      / 10000002"
puts "   Advisor     → advisor@erpcat.com      / 10000003"
puts "   Technician  → technician@erpcat.com   / 10000004"
puts "   LogisticsUser → logistics@erpcat.com  / 10000005"
puts "   Warehouseman  → warehouse@erpcat.com  / 10000006"
puts "   Client      → cliente@erpcat.com      / 10000007"
puts ""
puts "📊 TOTALES EN BD:"
puts "   Vehicle Types:    #{VehicleType.count}"
puts "   Vehicle Models:   #{VehicleModel.count}"
puts "   Spare Part Cats:  #{SparePartCategory.count}"
puts "   Products:         #{Product.count}"
puts "   Suppliers:        #{Supplier.count}"
puts "   Clients:          #{Client.count}"
puts "   Leads:            #{Lead.count}"
puts "   Quotations:       #{Quotation.count}"
puts "   Maintenances:     #{Maintenance.count}"
puts "   Users:            #{User.count}"
puts ""
