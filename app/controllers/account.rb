# encoding: utf-8
Store::App.controllers :account do
  

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
      @note="服务器忙，请稍候重试！"
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
      #如果选择记住,则保留2个星期cookie信息,key为'user'
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

end
