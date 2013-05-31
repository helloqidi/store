class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :crypted_password
      t.integer :role
      t.string :ip
      t.timestamps
    end
    add_index :users, :email, :unique => true
  end

  def self.down
    drop_table :users
  end
end
