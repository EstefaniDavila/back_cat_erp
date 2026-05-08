source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.3"

gem "rails", "~> 7.0.8", ">= 7.0.8.1"

gem "puma", "~> 5.0"
gem "redis", "~> 4.0"
gem "pg", "~> 1.1"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "dotenv-rails", :groups => [:development, :test, :production]
gem "bootsnap", require: false
gem "sprockets-rails"
gem "stimulus-rails"
gem "turbo-rails"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.7"


gem "api_guard"
gem "kaminari"
gem "pundit"
gem 'rack-cors', :require => 'rack/cors'
gem "responders"
gem "useragent"
gem "ransack"
gem 'jwt'
gem "carrierwave", ">= 3.0.0.beta", "< 4.0"
gem 'mini_magick'
gem 'rmagick'

gem "sidekiq"
gem "image_processing", ">= 1.2"
gem 'aws-sdk-s3', '~> 1'
gem "wicked_pdf"
gem "wkhtmltopdf-binary"
gem "dry-initializer"
gem "faraday"
gem "base64", "0.1.1"
gem 'faraday-retry'
gem 'lograge'
gem 'paper_trail'
gem 'connection_pool', '< 3.0'
gem 'sidekiq-cron'


group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end
  
gem 'dotenv-rails', groups: [:development, :test, :replica]

group :development do
  gem "web-console"
  gem "faker"
  gem "capistrano", "~> 3.17", require: false
  gem "capistrano-rails", "~> 1.6", ">= 1.6.2", require: false
  gem "capistrano-passenger", "~> 0.2", ">= 0.2.1", require: false
  gem "capistrano-rbenv", "~> 2.2", require: false
  gem "ed25519", ">= 1.2", "< 2.0", require: false
  gem "bcrypt_pbkdf", ">= 1.0", "< 2.0", require: false
  gem "rufo"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem "minitest", "< 6.0"
end