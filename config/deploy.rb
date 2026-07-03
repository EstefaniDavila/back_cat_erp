lock "~> 3.20.0"

set :application, "davcat"
set :repo_url, "git@github.com:EstefaniDavila/back_cat_erp.git"
set :branch, :main

set :deploy_to, "/root/davcat"

append :linked_files, "config/keys/private.pem"

append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "storage"

set :keep_releases, 5

set :rbenv_type, :user
set :rbenv_ruby, "3.3.3"

# Configuración de Sidekiq Systemd
set :pty, false
set :sidekiq_service_unit_user, :system