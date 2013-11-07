# encoding: utf-8
Store::App.controllers :recommend do

  before do
    @css_recommend = true
  end


  #推荐内容的展示页面
  get :show, :with => :id do
    @recommend = Recommend.find_by_id(params[:id])
    if @recommend.blank?
      flash[:error]="您访问的页面不存在哦"
      redirect url(:home,:recommend)
    end

    @recommend_user = @recommend.user
      
    render "recommend/show"
  end

end
