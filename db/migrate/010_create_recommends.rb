class CreateRecommends < ActiveRecord::Migration
  def self.up
    create_table :recommends do |t|
      t.string  "title",                            :null => false
      t.string  "sub_title"
      t.text    "description",  :limit => 16777215, :null => false
      t.integer "status",       :limit => 3,        :null => false
      t.integer "sort",         :limit => 3,        :null => false
      t.string  "tags"
      t.integer "category_id",                      :null => false
      t.integer "user_id",                          :null => false
      t.string  "store_url"
      t.string  "store_name"
      t.integer "comment_cnt"
      t.integer "up_cnt"
      t.integer "down_cnt"
      t.integer "favorite_cnt"

      t.timestamps
    end
  end

  def self.down
    drop_table :recommends
  end
end
