class ChangeUserPassword < ActiveRecord::Migration
  def self.up
    change_column(:users, :crypted_password, :string, :null=>false)
  end

  def self.down
    change_column(:users, :crypted_password, :string, :null=>true)
  end
end
