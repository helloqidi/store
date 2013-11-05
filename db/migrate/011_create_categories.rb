class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string    "name",                 :null => false
      t.integer   "parent_id",            :null => false
      t.integer   "level",  :limit => 3,  :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :categories
  end
end
