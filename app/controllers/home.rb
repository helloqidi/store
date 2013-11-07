# encoding: utf-8
Store::App.controllers :home do

  before(:recommend) do
    @css_recommend = true
  end
  before(:share) do
    @css_share = true
  end
  before(:found) do
    @css_found = true
  end


  #首页
  get :index do
    render "home/index"
  end

  #所有推荐内容
  get :recommend, :map=>"/" do
    @recommends = Recommend.published.paginate(:page => params[:page], :per_page => 15)

    render "home/recommend_list"
  end

  #晒单页面
  get :share do
    render "home/share_list"
  end

  #发现频道页面
  get :found do
    render "home/found_list"
  end

end
