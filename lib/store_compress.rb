# encoding: utf-8
class StoreCompress

  def self.compress_js_css
    compress_js
    compress_css
  end


  #压缩js文件
  def self.compress_js
    path=File.join(Padrino.root,'public/javascripts')
    files=["application.js","jquery.taconite.js"]
    compress_file="compress_js.js"

    data=""
    files.each do |name|
      file=File.join(path,name)
      data+=File.read(file)
    end

    compressor = YUI::JavaScriptCompressor.new
    compress_js=File.new(File.join(path,compress_file), "w")
    compress_js.write(compressor.compress(data))
    compress_js.close
  end

  #压缩css文件
  def self.compress_css
    path=File.join(Padrino.root,'public/stylesheets')
    files=["base.css"]
    compress_file="compress_css.css"

    data=""
    files.each do |name|
      file=File.join(path,name)
      data+=File.read(file)
    end

    compressor = YUI::CssCompressor.new
    compress_css=File.new(File.join(path,compress_file), "w")
    compress_css.write(compressor.compress(data))
    compress_css.close
  end

end
