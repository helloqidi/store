class ModifyDescFileToPhotos < ActiveRecord::Migration
  def self.up
    change_column(:photos, :file, :string,  :null=>true)
  end

  def self.down
    change_column(:photos, :file, :string,  :null=>false)
  end
end
