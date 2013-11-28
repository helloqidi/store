class CreateLinklabs < ActiveRecord::Migration
  def self.up
    create_table :linklabs do |t|
      t.integer "recommend_id",       :null => false
      t.integer "click_cnt"

      t.timestamps
    end
  end

  def self.down
    drop_table :linklabs
  end
end
