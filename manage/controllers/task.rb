# encoding: utf-8
Store::Manage.controllers :task do

  before do
    authenticate_system
    @css_task = true
  end

  #任务列表
  get :list do
    render "task/list"
  end

  #抓取smzdm数据
  get :scraping_smzdm do
    Jobs::Scraping::Smzdm.perform

    @success =  true
    @note = "抓取成功"
    content_type 'text/xml'
    render "task/scraping_smzdm"
  end

  #抓取huihui数据
  get :scraping_huihui do
    Jobs::Scraping::Huihui.perform

    @success =  true
    @note = "抓取成功"
    content_type 'text/xml'
    render "task/scraping_huihui"
  end

end
