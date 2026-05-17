# scripts/create_advisor.rb
advisor = Advisor.find_or_initialize_by(email: 'asesor_demo@example.com')
advisor.assign_attributes(
  first_name: 'Asesor',
  last_name: 'Demo',
  full_name: 'Asesor Demo',
  document_number: '98765432',
  document_type: 'DNI',
  code: 'AS-001',
  status: 'active'
)

if advisor.save
  puts "Asesor creado con éxito: #{advisor.full_name}"
  puts "Usuario asociado creado con email: #{advisor.email} y password: #{advisor.document_number}"
else
  puts "Error al crear el asesor: #{advisor.errors.full_messages.join(', ')}"
end
