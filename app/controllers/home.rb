# encoding: utf-8
Store::App.controllers :home do

  before(:recommend) do
    @css_recommend = true
  end
  before(:exp) do
    @css_exp = true
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
    @recommends = Recommend.published.recent.paginate(:page => params[:page], :per_page => 15)

    render "home/recommend_list"
  end

  #经验广场
  get :exp do
    @recommends = Recommend.exp.published.recent.paginate(:page => params[:page], :per_page => 15)

    render "home/exp_list"
  end

  #发现频道页面
  get :found do
    logger.debug(params)
    store_name = params[:store_name]
  
    if store_name.blank?
      @recommends = Recommend.published.paginate(:page => params[:page], :per_page => 20)
    else
      @recommends = Recommend.published.recent.where(:store_name=>store_name).paginate(:page => params[:page], :per_page => 20)
    end

    render "home/found_list"
  end

  #链接跳转
  get :go, :with => :id do
    redirect url(:home,:recommend) if params[:id].blank?
    linklab= Linklab.find(params[:id])

    if linklab.blank?
      flash[:error]="您访问的页面不存在哦"
      redirect url(:home,:recommend)
    end
    
    recommend = linklab.recommend
    if recommend.blank? || recommend.store_url.blank?
      flash[:error]="您访问的页面不存在哦"
      redirect url(:home,:recommend)
    end

    #递增1
    linklab.increment!(:click_cnt,1)
    redirect url(recommend.store_url)
  end

end
