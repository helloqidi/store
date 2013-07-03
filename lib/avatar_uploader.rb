# encoding: utf-8
class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  #存储在文件中
  storage :file
  
  #process :resize_to_fit => [80, 80]
  #process :convert => 'png' 
 
  version :small do
    process :resize_to_fill => [30, 30]
  end

  version :middle do
    process :resize_to_fill => [50, 50]
  end
  
  version :big do
    process :resize_to_fill => [100, 100]
  end


  #文件名
  def filename
    #加上avatar后,将会把各version分别建立文件夹来存储
    if super.present?
      "avatar/#{model.id}.#{file.extension.downcase}"
    end
  end

  #在publice下用于存储的文件夹名字
  def store_dir
    "#{model.class.to_s.underscore}"
  end

  #默认头像地址
  def default_url
   "/images/default_logo.jpg"
  end

  #允许上传的文件
  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
