role_params = { "first_name"=>"Test", "last_name"=>"Test", "email"=>"test@test.com", "document_number"=>"88888888", "document_type"=>"DNI", "full_name"=>"Test Test" }
roleable_type = "Advisor"
role_class = roleable_type.constantize
@role = role_class.new(role_params)
@role.status = "active"
@role.code = "ADV-12345"
if @role.save
  puts "SUCCESS: #{@role.id}"
else
  puts "FAILED: #{@role.errors.full_messages.join(', ')}"
end
