class ModifyPhotoesTableName < ActiveRecord::Migration
  def self.up
    rename_table :photoes, :photos
  end

  def self.down
    rename_table :photos, :photoes
  end
end
