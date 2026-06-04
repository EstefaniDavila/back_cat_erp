require 'json'
params = {
  roleable_type: "Advisor",
  role_attributes: {
    first_name: "aa",
    last_name: "bb",
    full_name: "aa bb",
    email: "7845122@erpcat.com",
    document_number: "7845122",
    document_type: "DNI"
  }
}

roleable_type = params[:roleable_type]
role_class = roleable_type.constantize
@role = role_class.new(params[:role_attributes])

if @role.respond_to?(:status=) && @role.status.blank?
  @role.status = 'active'
end

if @role.respond_to?(:code=) && @role.code.blank?
  @role.code = "#{roleable_type[0..2].upcase}-#{SecureRandom.hex(4).upcase}"
end

if @role.save
  puts "SAVED. ID: #{@role.id}"
else
  puts "ERRORS: #{@role.errors.full_messages}"
end
