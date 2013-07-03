# encoding: utf-8
module HelpersAuth
  def self.included(base) 
    base.send :extend, ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
  end

  module InstanceMethods
 
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

    #验证登录
    def auth_login
      deny_access unless login?
    end

    #禁止访问的跳转
    def deny_access
      flash[:error] ="请先登录！"
      redirect url(:account,:login)
    end

  end
end
