source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.0'

gem 'rspec-rails', '~> 6.0'
gem 'rails', '~> 6.1.7'
gem 'pg', '>= 1.1'
gem 'puma', '~> 5.0'
gem 'bcrypt', '~> 3.1.7' 
gem 'jwt', '~> 2.0'  
gem 'dotenv-rails', groups: [:development, :test]
gem 'concurrent-ruby', '1.3.4'
gem 'cpf_cnpj'

gem 'bootsnap', '>= 1.4.2', require: false

gem 'rack-cors'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
end

group :development do
  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
