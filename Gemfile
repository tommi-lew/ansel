source 'https://rubygems.org'
ruby '2.3.0'

gem 'rails', '4.2.6'
gem 'rails-observers'
gem 'pg'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'squeel'
gem 'browserstack-screenshot'

# Application server
gem 'passenger'

# Errors and Exceptions
gem 'rollbar', '~> 2.8.3'
gem 'oj', '~> 2.12.14'

# Background jobs
gem 'sidekiq'

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.0'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :production do
  # Heroku
  gem 'rails_12factor'
end

group :development, :test do
  gem 'byebug'
  gem 'rspec-rails', '~> 3.0'
  gem 'rspec-activejob'
  gem 'spring-commands-rspec'
  gem 'factory_girl_rails'
  gem 'dotenv-rails'
end

group :development do
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem 'timecop'
  gem 'awesome_print'
end

group :test do
  gem 'shoulda-matchers', require: false
  gem 'rr', require: false
  gem 'capybara', require: false
  gem 'webmock'
end
