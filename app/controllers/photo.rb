# encoding: utf-8
Store::App.controllers :photo do

  #删除图片
  delete :delete,:with=>:id, :csrf_protection => false do
    @photo=Photo.find_by_id(params[:id])
    if @photo.destroy
      @success=true
    else
      @success=false
      @note=Settings[:site_error_info]
    end
    content_type 'text/xml'
    render "photo/delete"
  end

  #通过编辑器上传图片
  #参数：
  #{"param2"=>"value2", "Filename"=>"little.jpg", "param1"=>"value1", "dir"=>"1", "pictitle"=>"little.jpg", "fileName"=>"little.jpg", "upfile"=>{:filename=>"little.jpg", :type=>"application/octet-stream", :name=>"upfile", :tempfile=>#<Tempfile:/tmp/RackMultipart20130705-12974-fj58bg>, :head=>"Content-Disposition: form-data; name=\"upfile\"; filename=\"little.jpg\"\r\nContent-Type: application/octet-stream\r\n"}, "Upload"=>"Submit Query"}
  #
  post :upload, :csrf_protection => false do
    logger.debug(params)
    photo=Photo.new(:file=>params[:upfile],:sort=>Photo::SORT[:item_desc])
    if photo.save
      return {:url=>photo.file.url(:big),:title=>params[:pictitle],:state=>"SUCCESS"}.to_json
    else
      return {:state=>"FAIL"}.to_json
    end

  end

end
