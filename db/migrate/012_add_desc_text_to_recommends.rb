class AddDescTextToRecommends < ActiveRecord::Migration
  def self.up
    add_column :recommends, :desc_text, :string, :limit => 16777215
  end

  def self.down
    remove_column :recommends, :desc_text
  end
end
