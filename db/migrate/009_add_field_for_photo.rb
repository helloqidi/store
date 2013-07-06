class AddFieldForPhoto < ActiveRecord::Migration
  def self.up
    add_column :photos, :quote, :integer, :limit=>1
  end

  def self.down
    remove_column :photos, :quote
  end
end
