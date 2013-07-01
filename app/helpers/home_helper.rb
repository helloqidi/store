# encoding: utf-8
Store::App.helpers do

  #当前用户
  def current_user
    return @current_user if @current_user
    return @current_user = User.find_by_id(session[:user_id]) if session[:user_id]
    if request.cookies['user'] && (@current_user = User.validate_cookie(request.cookies['user']))
      session[:user_id] = @current_user.id
      return @current_user
    end
  end

  #是否已登录
  def login?
    current_user ? true : false
  end

end
