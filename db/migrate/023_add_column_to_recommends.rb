class AddColumnToRecommends < ActiveRecord::Migration
  def self.up
    add_column :recommends, :linklab_id, :integer
  end

  def self.down
    remove_column :recommends, :linklab_id
  end
end
