# encoding: utf-8
class Category < ActiveRecord::Base

  ##关系
  has_many :recommends, :foreign_key=>"category_id"


  #校验
  validates :name, :presence=>true
  validates :parent_id, :presence=>true
  validates :level, :presence=>true

  ##回调
  before_validation :default_values

  ##过滤
  scope :roots, -> { where(level: 1) }
  scope :seconds, -> { where(level: 2) }

  private
  def default_values
    self.parent_id ||= 0

    #暂时只有两个级别
    if self.parent_id == 0
      self.level = 1
    else
      self.level = 2
    end
  end

end
