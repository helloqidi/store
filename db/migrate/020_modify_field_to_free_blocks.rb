class ModifyFieldToFreeBlocks < ActiveRecord::Migration
  def self.up
    change_column(:free_blocks, :content_text, :text, :limit=>16777215)
    change_column(:free_blocks, :content, :text, :limit=>16777215)
  end

  def self.down
    change_column(:free_blocks, :content_text, :string)
    change_column(:free_blocks, :content, :string)
  end
end
