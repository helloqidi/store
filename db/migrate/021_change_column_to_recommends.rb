class ChangeColumnToRecommends < ActiveRecord::Migration
  def self.up
    change_column(:recommends, :desc_text, :text, :limit=>16777215)
  end

  def self.down
    change_column(:recommends, :desc_text, :text, :limit=>2147483647)
  end
end
