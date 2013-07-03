# encoding: utf-8
Store::App.controllers :item do

  #新建商品
  get :new do
    @item = Item.new
    render "item/new"
  end

  #新建商品保存
  post :create do
    logger.debug(params)

    @item=Item.new(params[:item])

    begin
      ActiveRecord::Base.transaction do
        if @item.save
          #多图片上传
          if params[:photo][:file].present?
            params[:photo][:file].each do |file|
              @item.photos.create(:file=>file,:sort=>Photo::SORT[:item_main])
            end
          end
          @success=true
          @note="创建成功！"
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
    @item=Item.find(params[:id].to_i)
    render "item/show"
  end

end
