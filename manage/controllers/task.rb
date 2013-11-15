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

  #抓取数据
  get :scraping_smzdm do
    Jobs::Scraping::Smzdm.perform

    @success =  true
    @note = "正在抓取..."
    content_type 'text/xml'
    render "task/scraping_smzdm"
  end

end
