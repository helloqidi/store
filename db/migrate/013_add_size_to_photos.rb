class AddSizeToPhotos < ActiveRecord::Migration
  def self.up
    add_column :photos, :width, :string
    add_column :photos, :height, :string
    add_column :photos, :width_big, :string
    add_column :photos, :height_big, :string
    add_column :photos, :width_middle, :string
    add_column :photos, :height_middle, :string
    add_column :photos, :width_small, :string
    add_column :photos, :height_small, :string
  end

  def self.down
    remove_column :photos, :width
    remove_column :photos, :height
    remove_column :photos, :width_big
    remove_column :photos, :height_big
    remove_column :photos, :width_middle
    remove_column :photos, :height_middle
    remove_column :photos, :width_small
    remove_column :photos, :height_small
  end
end
