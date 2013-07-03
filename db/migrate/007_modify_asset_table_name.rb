class ModifyAssetTableName < ActiveRecord::Migration
  def self.up
    rename_table :assets, :photoes
  end

  def self.down
    rename_table :photoes, :assets
  end
end
