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

end
