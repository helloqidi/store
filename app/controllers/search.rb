# encoding: utf-8
Store::App.controllers :search do

  #搜索
  get :content do
    logger.debug(params)

    if params[:q].blank?
      flash[:error]="请输入搜索关键词"
      redirect url(:home,:recommend)
    end
    
    key_word=params[:q]
    page=(params[:page] || 1).to_i
    per=15

    #参考 https://github.com/karmi/retire/tree/master/test/integration
    search=Tire.search('recommends') do
      query do
        match  [:title, :desc_text], "#{key_word}"
      end
      highlight :title, :desc_text
      from (page-1)*per
      size per
    end
    @results=search.results
    render "search/list"
  end


end
