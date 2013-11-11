class CreateFreeBlocks < ActiveRecord::Migration
  def self.up
    create_table :free_blocks do |t|
      t.string  "tag",                  :null => false
      t.string  "content"
      t.integer "order",  :limit => 3,  :null => false
      t.integer "status", :limit => 3,  :null => false
      t.string  "memo"

      t.timestamps
    end
  end

  def self.down
    drop_table :free_blocks
  end
end
