# scripts/mi_seed_completo.rb
# Uso: rails runner scripts/mi_seed_completo.rb
# 1. Crea vehículo con estado "logistic"
# 2. Asocia 2 productos spare_part a cada proveedor existente

puts "\n" + "=" * 60
puts "🚚 MI SEED COMPLETO"
puts "=" * 60

# =============================================================================
# PARTE 1: VEHÍCULO LOGISTIC
# =============================================================================

puts "\n📌 [1] Creando vehículo con estado 'logistic'..."

producto = Product.where(product_type: "vehicle").first

if producto.nil?
  puts "  ❌ No hay productos tipo vehicle"
  exit 1
end

vehicle_model = VehicleModel.first

if producto.vehicle.present?
  producto.vehicle.update(status: "logistic")
  puts "  ✅ Vehículo actualizado: #{producto.vehicle.serial} → estado: logistic"
else
  vehicle = Vehicle.create!(
    product_id: producto.id,
    vehicle_model_id: vehicle_model.id,
    serial: "LOG-#{Time.current.to_i}",
    manufacture_year: 2024,
    status: "logistic",
    location: "Depósito Logístico",
    hours_used: 0,
    price_per_hour: 85.00,
    price_per_day: 1800.00
  )
  puts "  ✅ Vehículo creado: #{vehicle.serial} → estado: logistic"
end

# =============================================================================
# PARTE 2: ASOCIAR PROVEEDORES CON PRODUCTOS
# =============================================================================

puts "\n📌 [2] Asociando 2 productos spare_part a cada proveedor..."

# Obtener proveedores existentes
proveedores = Supplier.all.to_a
puts "  📦 Proveedores encontrados: #{proveedores.count}"

# Obtener productos spare_part existentes
productos_spare = Product.where(product_type: "spare_part").to_a
puts "  🔧 Productos spare_part encontrados: #{productos_spare.count}"

if proveedores.empty? || productos_spare.empty?
  puts "  ❌ Faltan proveedores o productos spare_part"
  exit 1
end

asociaciones_creadas = 0

proveedores.each_with_index do |proveedor, idx|
  # Tomar 2 productos diferentes para cada proveedor (evitar duplicados)
  productos_para_asociar = productos_spare[idx * 2, 2]
  
  # Si no hay suficientes productos, empezar desde el inicio
  if productos_para_asociar.compact.empty?
    productos_para_asociar = productos_spare[0, 2]
  end
  
  productos_para_asociar.each do |producto|
    # Verificar si ya existe la asociación
    unless SupplierProduct.exists?(supplier_id: proveedor.id, product_id: producto.id)
      SupplierProduct.create!(
        supplier_id: proveedor.id,
        product_id: producto.id,
        supplier_code: "#{proveedor.code}-#{producto.code}",
        unit_cost: producto.base_price * 0.70,
        lead_time_days: rand(5..20)
      )
      asociaciones_creadas += 1
      puts "  ✅ #{proveedor.business_name} → #{producto.name}"
    else
      puts "  ⏭️  #{proveedor.business_name} → #{producto.name} (ya existe)"
    end
  end
end

# =============================================================================
# VERIFICACIÓN FINAL
# =============================================================================

puts "\n" + "=" * 60
puts "📊 VERIFICACIÓN FINAL"
puts "=" * 60

puts "\n🚗 VEHÍCULOS LOGISTIC:"
Vehicle.where(status: "logistic").each do |v|
  puts "  - #{v.serial} | Estado: #{v.status} | Producto: #{v.product.name}"
end

puts "\n🔗 PROVEEDORES CON PRODUCTOS:"
Supplier.all.each do |s|
  count = SupplierProduct.where(supplier_id: s.id).count
  puts "  📦 #{s.business_name}: #{count} productos asociados"
end

puts "\n" + "=" * 60
puts "✅ COMPLETADO"
puts "   Vehículos logistic: #{Vehicle.where(status: "logistic").count}"
puts "   Asociaciones SupplierProduct: #{SupplierProduct.count}"
puts "=" * 60