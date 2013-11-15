# encoding: utf-8
namespace :scraping_smzdm do


  desc 'scraping home items'
  task :home_items => :environment do
    Jobs::Scraping::Smzdm.perform
  end

end
