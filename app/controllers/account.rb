# encoding: utf-8
Store::App.controllers :account do
  
  before(:edit_profile) do
    auth_login
  end 

  #注册页面
  get :register do
    render "account/register"
  end
  
  #注册提交
  post :register_create do
    logger.debug(params)
    logger.debug(request.xhr?)
    @user=User.new(params[:user])
    if @user.save
      @success=true
    else
      @success=false
      @note=Settings[:site_error_info]
    end
    content_type 'text/xml'
    render "account/register_create"
  end

  #登录页面
  get :login do
    render "account/login"
  end

  #登录提交页面
  post :login_create do
    logger.debug(params)
    @user=User.authenticate(params[:email],params[:password])
    if @user
      session[:user_id] = @user.id
      #如果选择记住,则保留2个星期cookie信息,cookie的key为'user'
      response.set_cookie('user', {:value => @user.encrypt_cookie_value, :path => "/", :expires => 2.weeks.since, :httponly => true}) if params[:remember_me]
      @success=true
    else
      @success=false
      @note="用户名或密码错误！"
    end
    content_type 'text/xml'
    render "account/login_create"
  end

  #退出登录
  delete :logout, :csrf_protection => false do
    if login?
      session[:user_id] = nil
      response.delete_cookie("user",:path=>"/")
      flash[:notice] = "成功退出"
    end
    redirect url("/")
  end


  #个人资料编辑
  get :edit_profile do
    render "account/edit_profile"
  end

  #修改资料后的提交
  put :update_profile do
    logger.debug(params)
    @user=User.find_by_id(params[:id])
    if @user.blank?
      @success=false
      @note="该用户不存在！"
      content_type 'text/xml'
      return render "account/update_profile"
    end

    if @user.update_attributes(params[:user])
      @success=true
      @note="修改成功！"
    else
      @success=false
      @note=Settings[:site_error_info]
    end
    content_type 'text/xml'
    render "account/update_profile"
  end


end
