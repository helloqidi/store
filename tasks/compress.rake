# encoding: utf-8
namespace :compress do
  
  desc 'compress js and css'
  task :compress_js_css => :environment do
    StoreCompress.compress_js_css
  end

  desc 'compress js'
  task :compress_js => :environment do
    StoreCompress.compress_js
  end

  desc 'compress css'
  task :compress_css => :environment do
    StoreCompress.compress_css
  end

end
