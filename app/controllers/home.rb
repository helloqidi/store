# encoding: utf-8
Store::App.controllers :home do
  

  #首页
  get :index, :map=>"/" do
    render "home/index"
  end

  #所有推荐内容
  get :recommend do
    @recommends = Recommend.paginate(:page => params[:page], :per_page => 2)

    render "home/recommend_list"
  end

end
