# encoding: utf-8
Store::App.controllers :item do

  #新建商品
  get :new do
    @item = Item.new
    render "item/new"
  end

  #新建商品保存
  #参数：
  #{"authenticity_token"=>"b7e98c4529458761040e1334acab827acad5f6d7f69e32b5ad43aabe9dec60a9", "item"=>{"title"=>"撒旦分", "description"=>"<p>测试</p>"}, "photo"=>{"file"=>[{:filename=>"little.jpg", :type=>"image/jpeg", :name=>"photo[file][]", :tempfile=>#<Tempfile:/tmp/RackMultipart20130705-12974-19znxfw>, :head=>"Content-Disposition: form-data; name=\"photo[file][]\"; filename=\"little.jpg\"\r\nContent-Type: image/jpeg\r\n"}, "", ""]}}
  post :create do
    logger.debug(params)

    @item=Item.new(params[:item])

    begin
      #事务处理
      ActiveRecord::Base.transaction do
        if @item.save!
          #多图片上传
          if params[:photo][:file].present?
            params[:photo][:file].each do |file|
              #会有这种情况{...,"photo"=>{"file"=>["", "", ""]} }
              next if file.blank?
              @item.photos.create!(:file=>file,:sort=>Photo::SORT[:item_main])
            end
          end
          @success=true
          @note="创建成功！"
          @redirect_url=url(:item,:show,:id=>@item.id)
          content_type 'text/xml'
          return render "item/create"
        end
      end#transaction
    rescue Exception => e
      logger.warn("Error:item create:#{e.message}")
    end

    @success=false
    @note=Settings[:site_error_info]
    content_type 'text/xml'
    render "item/create"
  end

  #商品展示
  get :show, :with=>:id do
    @item=Item.find_by_id(params[:id].to_i)
    render "item/show"
  end

  #列表
  get :list do
    @items=Item.paginate(:page => params[:page], :per_page => 5)
    render "item/list"
  end

  #编辑页面
  get :edit, :with=>:id do
    @item=Item.find_by_id(params[:id])
    render "item/edit"
  end

  #编辑保存
  put :update,:with=>:id do
    logger.debug(params)
    
    @item=Item.find_by_id(params[:id])

    begin
      #事务处理
      ActiveRecord::Base.transaction do
        if @item.update_attributes!(params[:item])
          #多图片上传
          if params[:photo][:file].present?
            params[:photo][:file].each do |file|
              #会有这种情况{...,"photo"=>{"file"=>["", "", ""]} }
              next if file.blank?
              @item.photos.create!(:file=>file,:sort=>Photo::SORT[:item_main])
            end
          end
          @success=true
          @note="修改成功！"
          @redirect_url=url(:item,:show,:id=>@item.id)
          content_type 'text/xml'
          return render "item/update"
        end
      end#transaction
    rescue Exception => e
      logger.warn("Error:item update:#{e.message}")
    end

    @success=false
    @note=Settings[:site_error_info]
    content_type 'text/xml'
    render "item/update"
  end

  #搜索
  get :search do
    logger.debug(params)
    if params[:q].blank?
      flash[:error]="请输入搜索关键词"
      redirect url(:item,:list)
    end
    
    key_word=params[:q]
    page=(params[:page] || 1).to_i
    per=2

    #参考 https://github.com/karmi/retire/tree/master/test/integration
    search=Tire.search('items') do
      query do
        match :title, "#{key_word}"
      end
      highlight 'title'
      from (page-1)*per
      size per
    end
    @results=search.results
    render "item/search"
  end

end
