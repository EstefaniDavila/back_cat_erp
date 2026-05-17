# =============================================================================
# SEED MASIVO PARTE 2 - ERP CAT (CORREGIDO)
# Uso: rails runner scripts/seed_masivo_2.rb
# PREREQUISITO: Ejecutar seed_masivo.rb primero
# =============================================================================
puts "\n🚀 SEED MASIVO PARTE 2..."
puts "=" * 60

def log(msg)    = puts("  ✅ #{msg}")
def warn_log(m) = puts("  ⚠️  #{m}")

# ── Cargar referencias base ──────────────────────────────────
advisor    = Advisor.first
technician = Technician.first
logistics  = LogisticsUser.first
admin_user = User.joins("JOIN admins ON users.roleable_id = admins.id AND users.roleable_type = 'Admin'").first
advisor_user = advisor&.user

clients   = Client.where.not(document_number: "10000007").to_a
veh_prods = Product.where(product_type: "vehicle").to_a
sp_prods  = Product.where(product_type: "spare_part").to_a
vehicles  = Vehicle.all.to_a
suppliers = Supplier.all.to_a
spare_parts = SparePart.all.to_a

if advisor.nil? || admin_user.nil? || clients.empty?
  puts "❌ Faltan datos base. Ejecuta seed_masivo.rb primero."
  exit 1
end

# ── 14. CLIENT ADVISORS ──────────────────────────────────────
puts "\n📌 [14] Relación cliente-asesor..."
created = 0
clients.first(6).each_with_index do |cl, i|
  next if ClientAdvisor.exists?(client: cl, advisor: advisor)
  ClientAdvisor.create!(client: cl, advisor: advisor,
    role: "primary", active: true, assigned_at: rand(1..180).days.ago)
  created += 1
rescue => e; warn_log "ClientAdvisor: #{e.message}"
end
log "#{created} client_advisors creados"

# ── 15. LEADS ────────────────────────────────────────────────
puts "\n📌 [15] Leads..."
statuses   = %w[new contacted qualified proposal negotiation closed_won]
priorities = %w[low medium high urgent]
sources    = %w[web referral cold_call social_media event]
types      = %w[sale rental maintenance spare_parts]
created = 0
clients.each_with_index do |cl, i|
  next if Lead.exists?(client: cl)
  Lead.create!(
    name: "Lead #{i+1} - #{cl.business_name}",
    email: "lead#{i+1}@contacto.com",
    phone: "9#{rand(10000000..99999999)}",
    source: sources[i % sources.size],
    lead_type: types[i % types.size],
    status: statuses[i % statuses.size],
    priority: priorities[i % priorities.size],
    notes: "Interesado en maquinaria pesada para proyecto de construccion.",
    assigned_to: advisor, client: cl)
  created += 1
rescue => e; warn_log "Lead #{i+1}: #{e.message}"
end
log "#{created} leads creados"
leads = Lead.all.to_a

# ── 16. LEAD COMMENTS & STATUS HISTORIES ─────────────────────
puts "\n📌 [16] Comentarios y historial de leads..."
created = 0
leads.first(5).each do |lead|
  begin
    unless LeadComment.exists?(lead: lead)
      LeadComment.create!(lead: lead, user: advisor_user,
        message: "Primer contacto exitoso. Cliente interesado en cotizacion.")
    end
    # CORREGIDO: changed_by_id en lugar de changed_by (modelo usa class_name: 'User')
    unless LeadStatusHistory.exists?(lead: lead)
      LeadStatusHistory.create!(lead: lead, changed_by_id: advisor_user.id,
        status: lead.status)
    end
    created += 1
  rescue => e; warn_log "LeadHistory #{lead.id}: #{e.message}"
  end
end
log "#{created} comentarios/historiales de leads"

# ── 17. QUOTATIONS ───────────────────────────────────────────
puts "\n📌 [17] Cotizaciones..."
q_types    = %w[sale rental spare_parts maintenance]
q_statuses = %w[draft sent approved]
created = 0
quotations = []

clients.each_with_index do |cl, i|
  next if Quotation.exists?(client: cl, advisor: advisor)
  # Seleccionar producto según tipo
  type = q_types[i % q_types.size]
  product = type == "spare_parts" ? sp_prods[i % [sp_prods.size,1].max] : veh_prods[i % [veh_prods.size,1].max]
  next unless product

  # CustomerAsset para mantenimientos
  asset = CustomerAsset.where(client: cl).first

  ActiveRecord::Base.transaction do
    q = Quotation.create!(
      quotation_type: type,
      status: q_statuses[i % q_statuses.size],
      subtotal: product.base_price,
      tax: (product.base_price * 0.18).round(2),
      total: (product.base_price * 1.18).round(2),
      valid_until: 30.days.from_now.to_date,
      client: cl, advisor: advisor)
    # CORREGIDO: customer_asset es optional: true en el modelo
    QuotationItem.create!(
      description: product.name, quantity: 1,
      unit_price: product.base_price, total_price: product.base_price,
      item_type: type, quotation: q, product: product,
      customer_asset: (type == "maintenance" ? asset : nil))
    quotations << q
    created += 1
  end
rescue => e; warn_log "Quotation #{i+1}: #{e.message}"
end
log "#{created} cotizaciones creadas"

# ── 18. QUOTATION COMMENTS & STATUS HISTORIES ────────────────
puts "\n📌 [18] Comentarios de cotizaciones..."
created = 0
quotations.first(4).each do |q|
  begin
    unless QuotationComment.exists?(quotation: q)
      QuotationComment.create!(quotation: q, user: advisor_user,
        message: "Cotizacion revisada y enviada al cliente para aprobacion.")
    end
    unless QuotationStatusHistory.exists?(quotation: q)
      QuotationStatusHistory.create!(quotation: q, changed_by_id: advisor_user.id,
        status: q.status)
    end
    created += 1
  rescue => e; warn_log "QComment: #{e.message}"
  end
end
log "#{created} comentarios/historiales de cotizaciones"

# ── 19. AREA REQUESTS ────────────────────────────────────────
puts "\n📌 [19] Solicitudes de área..."
areas = %w[Tecnico Logistica Almacen Finanzas Ventas]
created = 0
quotations.first(3).each_with_index do |q, i|
  next if AreaRequest.exists?(quotation: q)
  AreaRequest.create!(quotation: q, created_by: advisor_user,
    area: areas[i % areas.size], name: "Solicitud tecnica #{i+1}",
    description: "Se requiere revision tecnica del equipo cotizado en #{q.code}.",
    status: "pending")
  created += 1
rescue => e; warn_log "AreaReq: #{e.message}"
end
log "#{created} area_requests creados"

# ── 20. SALES ORDERS ─────────────────────────────────────────
puts "\n📌 [20] Órdenes de venta..."
sale_quotations = quotations.select { |q| q.quotation_type == "sale" }.first(3)
created = 0
sales_orders = []
sale_quotations.each_with_index do |q, i|
  next if SalesOrder.exists?(quotation: q)
  so = SalesOrder.create!(
    code: "SO-#{q.code.presence || SecureRandom.hex(4).upcase}",
    status: "pending",
    total: q.total, notes: "Orden generada desde #{q.code}",
    quotation: q, client: q.client, advisor: advisor)
  sales_orders << so
  created += 1
rescue => e; warn_log "SalesOrder #{i+1}: #{e.message}"
end
log "#{created} sales_orders creados"

# ── 21. RENTALS ──────────────────────────────────────────────
puts "\n📌 [21] Rentals..."
rental_quotations = quotations.select { |q| q.quotation_type == "rental" }.first(2)
created = 0
rentals = []
rental_quotations.each_with_index do |q, i|
  next if Rental.exists?(quotation: q)
  vehicle = vehicles[i % [vehicles.size,1].max]
  next unless vehicle
  r = Rental.create!(
    code: "RNT-#{q.code.presence || SecureRandom.hex(4).upcase}",
    status: "pending",
    total: q.total, start_date: 5.days.from_now.to_date,
    end_date: 35.days.from_now.to_date,
    quotation: q, client: q.client, vehicle: vehicle)
  rentals << r
  created += 1
rescue => e; warn_log "Rental #{i+1}: #{e.message}"
end
log "#{created} rentals creados"

# ── 22. MAINTENANCES ─────────────────────────────────────────
puts "\n📌 [22] Mantenimientos..."
mnt_types = %w[preventive corrective]
mnt_stats = %w[pending in_progress completed]
prios     = %w[low medium high]
created = 0
maintenances = []
clients.each_with_index do |cl, i|
  next if Maintenance.where(client: cl).exists?
  asset = CustomerAsset.where(client: cl).first
  mnt = Maintenance.create!(
    description: "Mantenimiento #{mnt_types[i%2]} - unidad #{i+1}",
    maintenance_type: mnt_types[i % 2],
    priority: prios[i % 3],
    status: mnt_stats[i % 3],
    requested_at: rand(1..30).days.ago,
    client: cl, customer_asset: asset)
  maintenances << mnt
  created += 1
rescue => e; warn_log "Maintenance #{i+1}: #{e.message}"
end
log "#{created} mantenimientos creados"

# ── 23. MAINTENANCE REPORTS ──────────────────────────────────
puts "\n📌 [23] Reportes de mantenimiento..."
created = 0
maintenances.first(3).each do |mnt|
  next if MaintenanceReport.exists?(maintenance: mnt)
  # CORREGIDO: created_by con class_name: 'User' ya está en el modelo
  MaintenanceReport.create!(maintenance: mnt, created_by: admin_user,
    summary: "Resumen #{mnt.code}: revision completada.",
    details: "Se realizo revision integral. Parametros dentro del rango normal.",
    recommendations: "Cambio de filtros cada 500 horas operativas.")
  created += 1
rescue => e; warn_log "MntReport: #{e.message}"
end
log "#{created} maintenance_reports creados"

# ── 24. WORK ORDERS ──────────────────────────────────────────
puts "\n📌 [24] Órdenes de trabajo..."
wo_types = %w[diagnostic repair preventive]
wo_stats = %w[open in_progress completed]
created = 0
work_orders = []
maintenances.first(6).each_with_index do |mnt, i|
  next if WorkOrder.where(maintenance: mnt).exists?
  wo = WorkOrder.create!(
    diagnosis: "Diagnostico inicial: #{["vibracion excesiva","sobrecalentamiento","fuga hidraulica"].sample}",
    diagnosis_result: ["pending","fault_found","no_fault"].sample,
    work_order_type: wo_types[i % wo_types.size],
    status: wo_stats[i % wo_stats.size],
    scheduled_date: rand(1..30).days.from_now,
    maintenance: mnt, assigned_to: technician)
  work_orders << wo
  created += 1
rescue => e; warn_log "WorkOrder #{i+1}: #{e.message}"
end
log "#{created} work_orders creados"

# ── 25. WORK ORDER ACTIONS ───────────────────────────────────
puts "\n📌 [25] Acciones de OT..."
actions = ["Inspeccion visual","Prueba presion hidraulica","Cambio de filtros","Ajuste de tension","Lubricacion general"]
created = 0
work_orders.first(4).each_with_index do |wo, i|
  next if WorkOrderAction.exists?(work_order: wo)
  WorkOrderAction.create!(work_order: wo, performed_by: technician,
    action: actions[i % actions.size],
    description: "Accion realizada: #{actions[i%actions.size].downcase}.")
  created += 1
rescue => e; warn_log "WOAction: #{e.message}"
end
log "#{created} work_order_actions creados"

# ── 26. WORK ORDER PARTS ─────────────────────────────────────
puts "\n📌 [26] Repuestos en OT..."
created = 0
work_orders.first(4).each_with_index do |wo, i|
  product = sp_prods[i % [sp_prods.size,1].max]
  next unless product
  next if WorkOrderPart.exists?(work_order: wo, product: product)
  WorkOrderPart.create!(work_order: wo, product: product,
    quantity: rand(1..3), unit_price: product.base_price)
  created += 1
rescue => e; warn_log "WOPart: #{e.message}"
end
log "#{created} work_order_parts creados"

# ── 27. PURCHASE ORDERS ──────────────────────────────────────
puts "\n📌 [27] Órdenes de compra..."
created = 0
purchase_orders = []
suppliers.first(3).each_with_index do |sup, i|
  po = PurchaseOrder.create!(
    status: "sent",
    expected_date: rand(7..30).days.from_now,
    notes: "OC para reposicion de stock - #{sup.business_name}.",
    supplier: sup, requested_by: admin_user)
  purchase_orders << po
  created += 1
rescue => e; warn_log "PO #{i+1}: #{e.message}"
end
log "#{created} purchase_orders creados"

# ── 28. PURCHASE ORDER ITEMS ─────────────────────────────────
puts "\n📌 [28] Items de OC..."
created = 0
purchase_orders.each_with_index do |po, i|
  product = sp_prods[i % [sp_prods.size,1].max]
  next unless product
  next if PurchaseOrderItem.exists?(purchase_order: po, product: product)
  PurchaseOrderItem.create!(purchase_order: po, product: product,
    quantity: rand(5..20), unit_cost: product.base_price * 0.7)
  created += 1
rescue => e; warn_log "POItem #{i+1}: #{e.message}"
end
log "#{created} purchase_order_items creados"

# ── 29. STOCK MOVEMENTS (manual IN) ──────────────────────────
puts "\n📌 [29] Movimientos de stock..."
created = 0
spare_parts.first(4).each_with_index do |sp, i|
  StockMovement.create!(spare_part: sp, performed_by: admin_user,
    movement_type: "IN", quantity: rand(5..20),
    reference: "INITIAL-STOCK-#{i+1}")
  created += 1
rescue => e; warn_log "StockMov: #{e.message}"
end
log "#{created} stock_movements creados"

# ── 30. DISPATCH ORDERS ──────────────────────────────────────
puts "\n📌 [30] Órdenes de despacho..."
sales_orders = SalesOrder.all.to_a
created = 0
dispatch_orders = []
sales_orders.first(2).each do |so|
  next if DispatchOrder.exists?(sales_order: so)
  dord = DispatchOrder.create!(status: "pending",
    prepared_by: admin_user, sales_order: so)
  dispatch_orders << dord
  created += 1
rescue => e; warn_log "DispOrder: #{e.message}"
end
log "#{created} dispatch_orders creados"

# ── 31. DISPATCH ITEMS ───────────────────────────────────────
puts "\n📌 [31] Items de despacho..."
created = 0
dispatch_orders.each_with_index do |dord, i|
  product = veh_prods[i % [veh_prods.size,1].max]
  next unless product
  next if DispatchItem.exists?(dispatch_order: dord, product: product)
  DispatchItem.create!(dispatch_order: dord, product: product,
    quantity: 1, checked: false)
  created += 1
rescue => e; warn_log "DispItem: #{e.message}"
end
log "#{created} dispatch_items creados"

# ── 32. DELIVERY GUIDES ──────────────────────────────────────
puts "\n📌 [32] Guías de entrega..."
logistic_vehicle = vehicles.find { |v| v.status == "available" } || vehicles.first
created = 0
dispatch_orders.each do |dord|
  next if DeliveryGuide.exists?(dispatch_order: dord)
  next unless logistics && logistic_vehicle
  DeliveryGuide.create!(
    guide_number: "GE-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.hex(3).upcase}",
    destination_address: "Av. Industrial #{rand(100..999)}, Lima",
    status: "pending",
    dispatch_order: dord, driver: logistics, vehicle: logistic_vehicle)
  created += 1
rescue => e; warn_log "DelivGuide: #{e.message}"
end
log "#{created} delivery_guides creados"

# ── 33. DELIVERY INCIDENTS ───────────────────────────────────
puts "\n📌 [33] Incidentes de entrega..."
guide = DeliveryGuide.first
created = 0
if guide && admin_user
  unless DeliveryIncident.exists?(delivery_guide: guide)
    DeliveryIncident.create!(delivery_guide: guide, reported_by: admin_user,
      incident_type: "delayed",
      description: "Retraso por congestion vehicular en ruta principal hacia Lima Norte.")
    created += 1
  end
end
log "#{created} delivery_incidents creados"

# ── 34. PRODUCT IMAGES ───────────────────────────────────────
puts "\n📌 [34] Imágenes de productos..."
created = 0
veh_prods.first(6).each do |p|
  next if ProductImage.exists?(product: p)
  ProductImage.create!(product: p, url: "https://placehold.co/600x400?text=#{CGI.escape(p.name)}")
  created += 1
rescue => e; warn_log "ProdImg: #{e.message}"
end
log "#{created} product_images creadas"

# ── 35. SUPPLIER PRODUCTS ────────────────────────────────────
puts "\n📌 [35] Proveedor-Producto..."
created = 0
sp_prods.first(5).each_with_index do |p, i|
  sup = suppliers[i % suppliers.size]
  next unless sup
  next if SupplierProduct.exists?(supplier: sup, product: p)
  SupplierProduct.create!(supplier: sup, product: p,
    supplier_code: "#{sup.code}-SP-#{i+1}",
    unit_cost: p.base_price * 0.7,
    lead_time_days: rand(5..30))
  created += 1
rescue => e; warn_log "SupProd: #{e.message}"
end
log "#{created} supplier_products adicionales creados"

# ── RESUMEN FINAL ────────────────────────────────────────────
puts "\n" + "=" * 60
puts "✅ SEED COMPLETO - TODAS LAS TABLAS"
puts "=" * 60
puts "\n👤 USUARIOS (DNI = Password):"
[
  ["admin@erpcat.com",      "10000001", "Admin"],
  ["manager@erpcat.com",    "10000002", "Manager"],
  ["advisor@erpcat.com",    "10000003", "Advisor"],
  ["technician@erpcat.com", "10000004", "Technician"],
  ["logistics@erpcat.com",  "10000005", "LogisticsUser"],
  ["warehouse@erpcat.com",  "10000006", "Warehouseman"],
  ["cliente@erpcat.com",    "10000007", "Client"],
].each { |email, dni, rol| puts "   %-30s %-12s %s" % [email, dni, rol] }

puts "\n📊 TOTALES EN BD:"
[
  ["Users",                 User.count],
  ["Admins",                Admin.count],
  ["Managers",              Manager.count],
  ["Advisors",              Advisor.count],
  ["Technicians",           Technician.count],
  ["LogisticsUsers",        LogisticsUser.count],
  ["Warehousemen",          Warehouseman.count],
  ["Clients",               Client.count],
  ["ClientContacts",        ClientContact.count],
  ["ClientAdvisors",        ClientAdvisor.count],
  ["CustomerAssets",        CustomerAsset.count],
  ["VehicleTypes",          VehicleType.count],
  ["VehicleModels",         VehicleModel.count],
  ["VehicleModelSpecs",     VehicleModelSpec.count],
  ["Products (total)",      Product.count],
  ["  → Vehicles",          Product.where(product_type:"vehicle").count],
  ["  → SpareParts",        Product.where(product_type:"spare_part").count],
  ["SparePartCategories",   SparePartCategory.count],
  ["SparePartSpecs",        SparePartSpec.count],
  ["SparePartCompats",      SparePartCompatibility.count],
  ["Suppliers",             Supplier.count],
  ["SupplierProducts",      SupplierProduct.count],
  ["Leads",                 Lead.count],
  ["LeadComments",          LeadComment.count],
  ["LeadStatusHistories",   LeadStatusHistory.count],
  ["Quotations",            Quotation.count],
  ["QuotationItems",        QuotationItem.count],
  ["QuotationComments",     QuotationComment.count],
  ["QuotationStatusHist",   QuotationStatusHistory.count],
  ["AreaRequests",          AreaRequest.count],
  ["SalesOrders",           SalesOrder.count],
  ["Rentals",               Rental.count],
  ["Maintenances",          Maintenance.count],
  ["MaintenanceReports",    MaintenanceReport.count],
  ["WorkOrders",            WorkOrder.count],
  ["WorkOrderActions",      WorkOrderAction.count],
  ["WorkOrderParts",        WorkOrderPart.count],
  ["PurchaseOrders",        PurchaseOrder.count],
  ["PurchaseOrderItems",    PurchaseOrderItem.count],
  ["StockMovements",        StockMovement.count],
  ["DispatchOrders",        DispatchOrder.count],
  ["DispatchItems",         DispatchItem.count],
  ["DeliveryGuides",        DeliveryGuide.count],
  ["DeliveryIncidents",     DeliveryIncident.count],
  ["ProductImages",         ProductImage.count],
].each { |label, count| puts "   %-28s %d" % [label + ":", count] }
puts ""
