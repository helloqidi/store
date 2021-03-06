# encoding: utf-8
class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  #存储在文件中
  #storage :file
  storage :qiniu

  process :store_geometry_original

  version :small do
    #resize_to_fill会裁剪宽度和高度都为180(貌似是居中裁剪)
    #process :resize_to_fill => [180, 180]
    #resize_to_fit会根据宽高比例,先确定宽度或者高度为180,再按照比例裁剪另一项
    #process :resize_to_fit => [180, 180]
    #resize_to_limit与resize_to_fit的效果类似,但它的优点是可以把宽度或者高度中任何一项设置为nil,以确定是按照宽度还是高度进行等比例裁剪
    process :resize_to_limit=>[180,180]
    process :store_geometry_small
  end

  version :middle do
    process :resize_to_limit => [380, nil]
    process :store_geometry_middle
  end
  
  version :big do
    process :resize_to_limit => [780, nil]
    process :store_geometry_big
  end


  #文件名
  def filename
    if super.present?
      # current_path 是 Carrierwave 上传过程临时创建的一个文件，有时间标记，所以它将是唯一的
      @name ||= Digest::MD5.hexdigest(File.dirname(current_path))
      "#{@name}.#{file.extension.downcase}"
    end
  end

  #在publice下用于存储的文件夹名字
  def store_dir
    "uploads/#{model.class.to_s.underscore}"
  end

  #默认图片地址
  def default_url
   "/images/default_#{version_name}.gif"
  end

  #允许上传的文件
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  #存储尺寸
  def store_geometry(size)
    return unless @file
    return unless model

    image = ::MiniMagick::Image::open(@file.file)
    if size == "big"
      model.width_big = image[:width]
      model.height_big = image[:height]
    elsif size == "middle"
      model.width_middle = image[:width]
      model.height_middle = image[:height]
    elsif size == "small"
      model.width_small = image[:width]
      model.height_small = image[:height]
    else
      model.width = image[:width]
      model.height = image[:height]
    end
  end

  def store_geometry_original
    self.store_geometry("original")
  end
  def store_geometry_big
    self.store_geometry("big")
  end
  def store_geometry_middle
    self.store_geometry("middle")
  end
  def store_geometry_small
    self.store_geometry("small")
  end
end
