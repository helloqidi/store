# encoding: utf-8
class Item < ActiveRecord::Base

  ##关系
  has_many :photos, :foreign_key=>"related_id"


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
  before_validation :default_values
  #检查描述中引用了哪些图片
  #after_save :check_photo_quote


  private
  def default_values
    self.status ||= STATUS[:draft]
  end

  def check_photo_quote
    return if self.description.blank?
    doc=Nokogiri::HTML(self.description)
    doc.css('img').each do |img|
      next unless img["src"].include?("photo")
      #src : /photo/small_90e2c82a83c3d7fd39fefb011367e846.jpg
      file_id=img["src"].split('_').second.split('.').first
      photo=Photo.where(:file=>file_id).first
      photo.update_column(:quote,Photo::QUOTE[:yes]) if photo.present?
    end
  end

end
