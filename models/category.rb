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
  scope :roots, -> { where(parent_id: 0) }

  private
  def default_values
    self.parent_id ||= 0
    self.level ||= 1
  end

end
