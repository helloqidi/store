# encoding: utf-8
Store::Manage.controllers :linklab do

  before do
    authenticate_admin
    @css_linklab_admin = true
  end

  #列表
  get :list do
    @linklabs = Linklab.bigger.includes(:recommend).paginate(:page => params[:page], :per_page => 15)
    render "linklab/list"
  end

end
