class ChangeUserFieldsType < ActiveRecord::Migration
  def self.up
    #默认string是varchar(255),integer是int(11)
    change_column(:users, :name, :string, :limit=>100,:null=>false)
    change_column(:users, :email, :string, :limit=>100,:null=>false)
    change_column(:users, :role, :integer, :limit=>3,:null=>false)
    change_column(:users, :ip, :string, :limit=>100)
  end

  def self.down
    change_column(:users, :name, :string, :limit=>255,:null=>true)
    change_column(:users, :email, :string, :limit=>255,:null=>true)
    change_column(:users, :role, :integer, :limit=>11,:null=>true)
    change_column(:users, :ip, :string, :limit=>255)
  end
end
