# encoding: utf-8
Store::App.controllers :account do
  

  #注册页面
  get :register do
    render "account/register"
  end
  
  #注册提交
  post :create do
  end

end
