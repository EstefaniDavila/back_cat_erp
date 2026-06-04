require 'net/http'
require 'json'
require 'uri'

# Simulate the exact request using a local HTTP post to production rails app
payload = {
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

uri = URI("http://localhost:3000/api/v1/admin/users")
req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
req.body = payload.to_json

# Send it
begin
  res = Net::HTTP.start(uri.hostname, uri.port) do |http|
    http.request(req)
  end
  puts "Status: #{res.code}"
  puts "Body: #{res.body}"
rescue => e
  puts "Error: #{e}"
end
