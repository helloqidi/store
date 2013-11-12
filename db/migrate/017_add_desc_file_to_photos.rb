class AddDescFileToPhotos < ActiveRecord::Migration
  def self.up
    add_column :photos, :desc_file, :string
  end

  def self.down
    remove_column :photos, :desc_file
  end
end
