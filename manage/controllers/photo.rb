# encoding: utf-8
Store::App.controllers :photo do

  #通过编辑器上传图片
  #参数：
  #{"param2"=>"value2", "Filename"=>"little.jpg", "param1"=>"value1", "dir"=>"1", "pictitle"=>"little.jpg", "fileName"=>"little.jpg", "upfile"=>{:filename=>"little.jpg", :type=>"application/octet-stream", :name=>"upfile", :tempfile=>#<Tempfile:/tmp/RackMultipart20130705-12974-fj58bg>, :head=>"Content-Disposition: form-data; name=\"upfile\"; filename=\"little.jpg\"\r\nContent-Type: application/octet-stream\r\n"}, "Upload"=>"Submit Query"}
  #
  post :recommend_upload, :csrf_protection => false do
    logger.debug(params)
    photo=Photo.new(:desc_file=>params[:upfile],:sort=>Photo::SORT[:recommend_desc])
    if photo.save
      return {:url=>photo.desc_file.url,:title=>params[:pictitle],:state=>"SUCCESS"}.to_json
    else
      return {:state=>"FAIL"}.to_json
    end

  end

  post :free_block_upload, :csrf_protection => false do
    logger.debug(params)
    photo=Photo.new(:desc_file=>params[:upfile],:sort=>Photo::SORT[:free_block_desc])
    if photo.save
      return {:url=>photo.desc_file.url,:title=>params[:pictitle],:state=>"SUCCESS"}.to_json
    else
      return {:state=>"FAIL"}.to_json
    end

  end
  
end
