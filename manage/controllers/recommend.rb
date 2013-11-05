# encoding: utf-8
Store::Manage.controllers :recommend do

  before do
    authenticate_admin
    @css_recommend_admin = true
  end

  #列表
  get :list do
    @recommends = Recommend.paginate(:page => params[:page], :per_page => 15)
    render "recommend/list"
  end

  #新建商品
  get :new do
    @recommend = Recommend.new
    render "recommend/new"
  end

  #新建保存
  post :create do
    logger.debug(params)
    params[:recommend][:user_id] = current_user.id

    @recommend=Recommend.new(params[:recommend])

    begin
      #事务处理
      ActiveRecord::Base.transaction do
        if @recommend.save!
          #多图片上传
          if params[:photo][:file].present?
            @recommend.photos.create!(:file=>params[:photo][:file],:sort=>Photo::SORT[:recommend_main])
          end
          @success=true
          @note="创建成功！"
          @redirect_url=url(:recommend,:list)
          content_type 'text/xml'
          return render "recommend/create"
        end
      end#transaction
    rescue Exception => e
      logger.warn("Error:recommend create:#{e.message}")
    end

    @success=false
    @note=Settings[:site_error_info]
    content_type 'text/xml'
    render "recommend/create"
  end


  #编辑
  get :edit, :with => :id do
    @recommend = Recommend.find(params[:id])
    render "recommend/edit"
  end

  #编辑保存
  put :update,:with=>:id do
    logger.debug(params)
    
    @recommend=Recommend.find(params[:id])

    begin
      #事务处理
      ActiveRecord::Base.transaction do
        if @recommend.update_attributes!(params[:recommend])
          #多图片上传
          if params[:photo][:file].present?
            #删除旧的
            @recommend.photos.recommend_main.destroy_all
            @recommend.photos.create!(:file=>params[:photo][:file],:sort=>Photo::SORT[:recommend_main])
          end
          @success=true
          @note="修改成功！"
          @redirect_url=url(:recommend,:list)
          content_type 'text/xml'
          return render "recommend/update"
        end
      end#transaction
    rescue Exception => e
      logger.warn("Error:recommend update:#{e.message}")
    end

    @success=false
    @note=Settings[:site_error_info]
    content_type 'text/xml'
    render "recommend/update"
  end

  #删除
  delete :delete,:with=>:id, :csrf_protection => false do
    @recommend = Recommend.find(params[:id])
    if @recommend.destroy
      @success=true
    else
      @success=false
      @note=Settings[:site_error_info]
    end
    content_type 'text/xml'
    render "recommend/delete"
  end

end
