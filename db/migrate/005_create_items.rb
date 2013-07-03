class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :title, :limit=>255, :null=>false
      # set limit 64k+1 to force column type longtext
      t.text :description, :limit => 64*1024+1, :null => false
      t.integer :status, :limit=>3, :null=>false
      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
