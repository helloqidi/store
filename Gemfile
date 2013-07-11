source 'http://ruby.taobao.org/'

## Project requirements
gem 'rake'
# Padrino Stable Gem
gem 'padrino', '~> 0.11'


## Component requirements
gem 'erubis', '~> 2.7.0'
gem 'activerecord', '>= 3.1', :require => 'active_record'
gem 'mysql2', '~> 0.3.11'
#password
gem 'bcrypt-ruby', '~> 3.1.1'
gem 'carrierwave', :require => ['carrierwave', 'carrierwave/orm/activerecord']
gem 'mini_magick', '~> 3.6.0'
#DSL for HTTP
gem 'rest-client', '~> 1.6.7'
#如果遇到nokogiri在服务器上用bundle:install不成功.可直接在服务器上 NOKOGIRI_USE_SYSTEM_LIBRARIES=true gem install nokogiri,此处通过path参数直接引用安装好的gem路径
gem 'nokogiri', '~> 1.6.0'
#full-text search
gem 'tire', '~> 0.6.0'
gem 'will_paginate', '~> 3.0.4', :require => ['will_paginate/active_record', 'will_paginate/view_helpers/sinatra']
#compress js/css
gem 'yui-compressor', '~> 0.9.6'

## Production requirements
group :production do
  gem 'rainbows', '~> 4.5.0'
end


## Development requirements
group :development do
  gem 'thin'
  #gem 'capistrano','~> 2.15.0'
  #gem 'rvm-capistrano', require: false
end


## Test requirements
