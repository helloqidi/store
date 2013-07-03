class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.integer :related_id, :null=>false
      t.string :file, :limit=>255
      t.integer :sort, :limit=>3, :null=>false
      t.string :file_type, :limit=>10
      t.integer :file_size
      t.timestamps
    end
  end

  def self.down
    drop_table :assets
  end
end
