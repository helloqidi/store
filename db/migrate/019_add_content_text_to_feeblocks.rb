class AddContentTextToFeeblocks < ActiveRecord::Migration
  def self.up
    add_column :free_blocks, :content_text, :string
  end

  def self.down
    remove_column :free_blocks, :content_text
  end
end
