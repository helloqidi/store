# encoding: utf-8
class Photo < ActiveRecord::Base
  #商品图片
  mount_uploader :file, PhotoUploader


  ##关系
  belongs_to :item, :foreign_key=>"related_id"
  belongs_to :recommend, :foreign_key=>"related_id"

  ##常量
  SORT={
    #商品主图
    :item_main=>1,
    #商品描述图
    :item_desc=>2,
    #推荐主图
    :recommend_main => 3,
    #推荐描述图
    :recommend_desc => 4
  }
  #是否被引用
  QUOTE={
    :yes=>0,
    :no=>1
  }

  ##验证
  #validates :related_id, :presence=>true
  validates :file, :presence=>true
  validates :sort, :presence=>true
  
  ##过滤
  scope :recommend_main, -> { where(sort: SORT[:recommend_main]) }


  before_save :save_image_dimensions


  private

    def save_image_dimensions
      logger.debug("========")
      if file_changed?
        logger.debug("width:#{file.geometry[:width]}")
        logger.debug("height:#{file.geometry[:height]}")
      end
    end

end
