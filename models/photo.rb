# encoding: utf-8
class Photo < ActiveRecord::Base
  #商品图片
  mount_uploader :file, PhotoUploader


  ##关系
  belongs_to :item, :foreign_key=>"related_id"


  ##常量
  SORT={
    #商品主图
    :item_main=>1,
    #商品描述图
    :item_desc=>2
  }

  ##验证
  validates :related_id, :presence=>true
  validates :file, :presence=>true
  validates :sort, :presence=>true
  

end
