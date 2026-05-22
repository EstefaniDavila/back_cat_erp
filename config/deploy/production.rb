server '198.199.70.32', user: 'root', roles: %w{app db web}

set :ssh_options, {
  forward_agent: true,
  auth_methods: %w(publickey)
}