PRIVATE_KEY = OpenSSL::PKey::RSA.new(
  File.read(Rails.root.join('config/keys/private.pem'))
)

PUBLIC_KEY = OpenSSL::PKey::RSA.new(
  File.read(Rails.root.join('config/keys/public.pem'))
)