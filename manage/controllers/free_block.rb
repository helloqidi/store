# encoding: utf-8
Store::Manage.controllers :free_block do

  before do
    authenticate_admin
    @css_free_block_admin = true
  end

  #列表
  get :list do
    @free_blocks = FreeBlock.paginate(:page => params[:page], :per_page => 15)
    render "free_block/list"
  end

  #创建
  get :new do
    @free_block = FreeBlock.new
    render "free_block/new"
  end

  #创建保存
  post :create do
    logger.debug(params)

    @free_block = FreeBlock.new(params[:free_block])
    if @free_block.save
      @success=true
      @note="创建成功！"
      @redirect_url=url(:free_block,:list)
      content_type 'text/xml'
      return render "free_block/create"
    else
      @success=false
      @note=Settings[:site_error_info]
      content_type 'text/xml'
      return render "free_block/create"
    end

  end

  #编辑
  get :edit, :with => :id do
    @free_block = FreeBlock.find_by_id(params[:id].to_i)
    render "free_block/edit"
  end

  #编辑保存
  put :update, :with => :id do
    logger.debug(params)

    @free_block = FreeBlock.find_by_id(params[:id])
    if @free_block.update_attributes!(params[:free_block])
      @success=true
      @note="修改成功！"
      @redirect_url=url(:free_block,:list)
      content_type 'text/xml'
      return render "free_block/update"
    else
      @success=false
      @note=Settings[:site_error_info]
      content_type 'text/xml'
      return render "free_block/update"
    end
  end


  #删除
  delete :delete,:with=>:id, :csrf_protection => false do
    @free_block = FreeBlock.find_by_id(params[:id])
    if @free_block.destroy
      @success=true
    else
      @success=false
      @note=Settings[:site_error_info]
    end
    content_type 'text/xml'
    render "free_block/delete"
  end

  #发布
  put :set_publish, :with => :id, :csrf_protection => false do
    @free_block = FreeBlock.find_by_id(params[:id])
    if @free_block.update_attribute(:status, FreeBlock::STATUS[:published])
      @success =  true
    else
      @success = false
      @note = "服务器忙,请稍候重试"
    end

    content_type 'text/xml'
    render "free_block/set_publish"
  end

end
