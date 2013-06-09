# rainbows config
# https://github.com/nilmethod/rainbows
# http://rainbows.rubyforge.org/Rainbows/Configurator.html
Rainbows! do
  # 设置并发模型
  use :ThreadPool # 使用线程池模式，进程启动的时候创建好线程数
  
  # 每个工作进程可以同时处理的连接数，应该根据服务器的配置、性能来配置。
  # rainbows所能处理的客户端连接数 = worker_processes x worker_connections
  worker_connections 10
  
end

# paths and things
wd          = File.expand_path('../../', __FILE__)
tmp_path    = File.join(wd, 'log')
Dir.mkdir(tmp_path) unless File.exist?(tmp_path)
socket_path = File.join(tmp_path, 'rainbows.sock')
pid_path    = File.join(tmp_path, 'rainbows.pid')
err_path    = File.join(tmp_path, 'rainbows.error.log')
out_path    = File.join(tmp_path, 'rainbows.out.log')

# Use at least one worker per core if you're on a dedicated server,
# more will usually help for _short_ waits on databases/caches.
# 子进程数（一般按照cpu的个数或者核数来确定）
# 可以通过 kill -s SIGTTIN和kill -s SIGTTOUTL来增减
worker_processes 1

# If running the master process as root and the workers as an unprivileged
# user, do this to switch euid/egid in the workers (also chowns logs):
# user "unprivileged_user", "unprivileged_group"

# tell it where to be
# 工作路径，一般是程序的根路径
working_directory wd

# listen on both a Unix domain socket and a TCP port,
# we use a shorter backlog for quicker failover when busy
listen 8080, :tcp_nopush => true

# nuke workers after 30 seconds instead of 60 seconds (the default)
timeout 30

# feel free to point this anywhere accessible on the filesystem
# 主进程pid文件的目录位置
pid pid_path

# By default, the Unicorn logger will write to stderr.
# Additionally, ome applications/frameworks log to stderr or stdout,
# so prevent them from going to /dev/null when daemonized here:
# 标准错误输出转向
stderr_path err_path
# 标准输出转向
stdout_path out_path

# 是否预读程序代码，默认false
preload_app true

# 设置用户和用户组
# user 'www', 'www'

before_fork do |server, worker|
  # # This allows a new master process to incrementally
  # # phase out the old master process with SIGTTOU to avoid a
  # # thundering herd (especially in the "preload_app false" case)
  # # when doing a transparent upgrade.  The last worker spawned
  # # will then kill off the old master process with a SIGQUIT.
  old_pid = "#{server.config[:pid]}.oldbin"

  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
  #
  # Throttle the master from forking too quickly by sleeping.  Due
  # to the implementation of standard Unix signal handlers, this
  # helps (but does not completely) prevent identical, repeated signals
  # from being lost when the receiving process is busy.
  # sleep 1
end

after_fork do |server, worker|
end
