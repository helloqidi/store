# encoding: utf-8
Store::Manage.controllers :user do

  before do
    authenticate_admin
    @css_user_admin = true
  end

  #列表
  get :list do
    @users = User.no_system.paginate(:page => params[:page], :per_page => 15)
    render "user/list"
  end

  #设为管理员
  put :set_admin, :with => :id, :csrf_protection => false do
    @user = User.find_by_id(params[:id])
    if @user.update_attribute(:role, User::ROLE[:admin])
      @success =  true
    else
      @success = false
      @note = "服务器忙,请稍候重试"
    end

    content_type 'text/xml'
    render "user/set_admin"
  end

end
