# encoding: utf-8
class FreeBlock < ActiveRecord::Base


  ##常量
  STATUS={
    #草稿状态
    :draft=>1,
    #发布状态
    :published=>2
  }

  ##验证
  validates :tag, :presence=>true
  validates :status, :presence=>true
  validates :order, :presence=>true

  ##回调
  before_validation :default_values

  ##过滤
  scope :draft, -> { where(status: STATUS[:draft]) }
  scope :published, -> { where(status: STATUS[:published]) }


  #是否已经发布了
  def published?
    return true if self.status == STATUS[:published]
    false
  end

  private
  def default_values
    self.status ||= STATUS[:draft]
    self.order ||= 1
  end

end
