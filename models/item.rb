# encoding: utf-8
class Item < ActiveRecord::Base

  ##关系

  ##常量
  STATUS={
    #草稿状态
    :draft=>1,
    #发布状态
    :published=>2
  }


  ##验证
  validates :title, :presence=>true
  validates :description, :presence=>true
  validates :status, :presence=>true
  

  ##回调
  before_save :default_values


  private
  def default_values
    self.status ||= STATUS[:draft]
  end

end
