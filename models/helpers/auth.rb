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
      redirect Store::App.url(:account,:login)
    end

    ## 管理员以上权限
    def authenticate_admin
      deny_access_admin unless admin?
    end
  
    #禁止访问
    def deny_access_admin
      flash[:notice] = "访问路径不存在!"
      redirect Store::App.url(:home,:index)
    end

    #是否管理员
    def admin?
      return false if current_user.blank?      
      return true if current_user.role == User::ROLE[:admin]
      return true if system?
      return false
    end

    #是否超级用户
    def system?
      return false if current_user.blank?      
      return true if current_user.role == User::ROLE[:system]
      return false      
    end

    #存储多说token
    def set_duoshuo_token(user)
      token = {"short_name"=>Settings[:duoshuo_short_name], "user_key"=>"#{user.id}", "name"=>user.name}
      logger.debug("duoshuo ...")
      logger.debug(token)
      duoshuo_token = JWT.encode(token, Settings[:duoshuo_secret])
      response.set_cookie('duoshuo_token', {:value => duoshuo_token, :path => "/", :expires => 2.weeks.since, :httponly => true}) 
    end

  end
end
