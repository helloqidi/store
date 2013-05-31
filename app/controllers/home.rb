# encoding: utf-8
Store::App.controllers :home do
  

  #首页
  get :index, :map=>"/" do
    render "home/index"
  end
  

end
