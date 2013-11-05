# encoding: utf-8
Store::Manage.controllers :category do

  before do
    @css_category_admin = true
  end

  #列表
  get :list do
    @categories = Category.paginate(:page => params[:page], :per_page => 15)
    render "category/list"
  end

  #编辑
  get :edit, :with => :id do
    @category = Category.find(params[:id].to_i)
    render "category/edit"
  end

  #编辑保存
  put :update, :with => :id do
    logger.debug(params)

    @category = Category.find(params[:id])
    if @category.update_attributes!(params[:category])
      @success=true
      @note="修改成功！"
      @redirect_url=url(:category,:list)
      content_type 'text/xml'
      return render "category/update"
    else
      @success=false
      @note=Settings[:site_error_info]
      content_type 'text/xml'
      return render "category/update"
    end
  end

  #创建
  get :new do
    @category = Category.new
    render "category/new"
  end

  #创建保存
  post :create do
    logger.debug(params)

    @category = Category.new(params[:category])
    if @category.save
      @success=true
      @note="创建成功！"
      @redirect_url=url(:category,:list)
      content_type 'text/xml'
      return render "category/create"
    else
      @success=false
      @note=Settings[:site_error_info]
      content_type 'text/xml'
      return render "category/create"
    end

  end


  #删除
  delete :delete,:with=>:id, :csrf_protection => false do
    @category = Category.find(params[:id])
    if @category.destroy
      @success=true
    else
      @success=false
      @note=Settings[:site_error_info]
    end
    content_type 'text/xml'
    render "category/delete"
  end

end
