# encoding: utf-8
class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  #存储在文件中
  storage :file

 
  version :small do
    process :resize_to_fill => [180, 180]
  end

  version :middle do
    process :resize_to_limit => [380, nil]
  end
  
  version :big do
    process :resize_to_limit => [780, nil]
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
    "#{model.class.to_s.underscore}"
  end

  #默认头像地址
  def default_url
   "photo/#{version_name}.gif"
  end

  #允许上传的文件
  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
