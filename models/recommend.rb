# encoding: utf-8
class Recommend < ActiveRecord::Base

  ##关系
  has_many :photos,     :foreign_key => "related_id"
  belongs_to :user,     :foreign_key => "user_id"
  belongs_to :category, :foreign_key => "category_id"


  ##常量
  STATUS={
    #草稿状态
    :draft=>1,
    #发布状态
    :published=>2
  }

  #备用类型字段
  SORT={
    :normal => 0
  }

  ##验证
  validates :title, :presence=>true
  validates :description, :presence=>true
  validates :status, :presence=>true
  validates :sort, :presence=>true
  validates :category_id, :presence=>true
  validates :user_id, :presence=>true

  ##回调
  before_validation :default_values

  private
  def default_values
    self.status ||= STATUS[:draft]
    self.sort ||= SORT[:normal]
  end
  
end
