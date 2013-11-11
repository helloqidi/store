class AddUsernameToRecommends < ActiveRecord::Migration
  def self.up
    add_column :recommends, :user_name, :string
  end

  def self.down
    remove_column :recommends, :user_name
  end
end
