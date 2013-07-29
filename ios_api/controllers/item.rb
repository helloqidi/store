# encoding: utf-8
Store::IosApi.controllers :item do

  before do
    content_type "application/json"
  end

  ##商品列表
  #请求：
  #page,per
  #返回：
  #{"result":"1",
  # "list":[
  #  {"id":"50d1aad0f9f8977c3f00001d","title":"xxx","created_at":"xxx","width_small":"180","height_small":"180","photo_small":"the img url"},
  #  {...}
  #  ]
  #}    
  get :index do
    begin
      page,per=page_per(params[:page],params[:per])
      list_array=[]

      items=Item.paginate(:page => params[:page], :per_page => 5)
      items.each do |item|
        if item.photos.present?
          photo_small_url=item.photos.first.file.url(:small)
        else
          photo_small_url=""
        end
        #组合hash信息
        list_hash={
          :id=>item.id,
          :title=>item.title,
          :created_at=>item.created_at,
          :width_small=>"180",
          :height_small=>"180",
          :photo_small=>domain_path(photo_small_url)
        }
        list_array<<list_hash
      end
      return {:result=>1,:list=>list_array}.to_json
    rescue=>e
      #返回错误信息
      return {:result=>-1,:errMsg=>e.message}.to_json
    end
  end




  # get :index, :map => '/foo/bar' do
  #   session[:foo] = 'bar'
  #   render 'index'
  # end

  # get :sample, :map => '/sample/url', :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   'Maps to url '/foo/#{params[:id]}''
  # end

  # get '/example' do
  #   'Hello world!'
  # end
  

end
