source 'http://ruby.taobao.org/'

## Project requirements
gem 'rake'
# Padrino Stable Gem
gem 'padrino', '~> 0.11'


## Component requirements
gem 'erubis', '~> 2.7.0'
gem 'activerecord', '>= 3.1', :require => 'active_record'
gem 'mysql2'
#password
gem 'bcrypt-ruby'
gem 'carrierwave', :require => ['carrierwave', 'carrierwave/orm/activerecord']
gem 'mini_magick'
#DSL for HTTP
gem 'rest-client'
#nokogiri在服务器上用cap deploy时bundle:install不成功,因为nokogiri-1.6.0依赖的gcc版本过高
gem 'nokogiri', "~> 1.5.10"
#full-text search
gem 'tire'
gem 'will_paginate', :require => ['will_paginate/active_record', 'will_paginate/view_helpers/sinatra']
#compress js/css
gem 'yui-compressor'

## Production requirements
group :production do
  gem 'rainbows'
end


## Development requirements
group :development do
  gem 'thin'
  gem 'capistrano','~> 2.15.0'
  gem 'rvm-capistrano', require: false
end


## Test requirements
