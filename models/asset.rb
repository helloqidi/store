# encoding: utf-8
class Asset < ActiveRecord::Base

  ##关系

  ##常量
  SORT={
    #头像
    :avatar=>1,
    #商品主图
    :item_main=>2
  }

  ##验证
  validates :related_id, :presence=>true
  validates :file, :presence=>true
  validates :sort, :presence=>true
  

end
