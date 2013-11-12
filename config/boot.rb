# Defines our constants
PADRINO_ENV  = ENV['PADRINO_ENV'] ||= ENV['RACK_ENV'] ||= 'development'  unless defined?(PADRINO_ENV)
PADRINO_ROOT = File.expand_path('../..', __FILE__) unless defined?(PADRINO_ROOT)

# Load our dependencies
require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
Bundler.require(:default, PADRINO_ENV)

##
# ## Enable devel logging
#
# Padrino::Logger::Config[:development][:log_level]  = :devel
# Padrino::Logger::Config[:development][:log_static] = true
#
# ## Configure your I18n
#
I18n.default_locale = 'zh_cn'

Dir.glob(File.expand_path("#{PADRINO_ROOT}/locale", __FILE__) + '/**/*.yml').each do |file|
  I18n.load_path << file
end

#will_paginate中文
WillPaginate::ViewHelpers.pagination_options[:previous_label] = '« 上一页'
WillPaginate::ViewHelpers.pagination_options[:next_label] = '下一页 »'

#CarrierWave
::CarrierWave.configure do |config|
  config.storage             = :qiniu
  config.qiniu_access_key    = "QPqYEAMobxb9yJApcclkXjDm_dCVR6CcDFI6y0Pa"
  config.qiniu_secret_key    = "JhVi8FUeNYonv_TjaUU6pjbN3M880S3jNGrRZSlb"
  config.qiniu_bucket        = "helloqidi"
  config.qiniu_bucket_domain = "helloqidi.u.qiniudn.com"
  config.qiniu_block_size    = 4*1024*1024
  config.qiniu_protocal      = "http"
end

#
# ## Configure your HTML5 data helpers
#
# Padrino::Helpers::TagHelpers::DATA_ATTRIBUTES.push(:dialog)
# text_field :foo, :dialog => true
# Generates: <input type="text" data-dialog="true" name="foo" />
#
# ## Add helpers to mailer
#
# Mail::Message.class_eval do
#   include Padrino::Helpers::NumberHelpers
#   include Padrino::Helpers::TranslationHelpers
# end

##
# Add your before (RE)load hooks here
#
Padrino.before_load do
end

##
# Add your after (RE)load hooks here
#
Padrino.after_load do
end


# load project config
# Settings[:site_title]
Settings = YAML.load_file(File.expand_path("#{PADRINO_ROOT}/config", __FILE__) + '/app_config.yml')[PADRINO_ENV].symbolize_keys



Padrino.load!
