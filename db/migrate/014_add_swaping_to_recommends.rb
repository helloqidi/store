class AddSwapingToRecommends < ActiveRecord::Migration
  def self.up
    add_column :recommends, :swaping_site, :string
    add_column :recommends, :swaping_url, :string
  end

  def self.down
    remove_column :recommends, :swaping_site
    remove_column :recommends, :swaping_url
  end
end
