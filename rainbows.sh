#!/bin/sh

# rainbows是一个ruby的web服务器（类似于thin）。
# 它会启动一个主进程（控制进程，相当于nginx），若干个子进程（工作进程，相当于thin），来运行程序。

# 重启rainbows rainbows对信号的支持非常全面，http://rainbows.rubyforge.org/SIGNALS.html。
# 所以重启非常简单，只要在更新了程序的代码之后，执行： kill -1 [rainbows的主进程id] 或 kill -s HUP [rainbows的主进程id]。

# set ruby GC parameters
# 修改 GC 参数提高 Ruby 性能
# GC参数设置，具体解释看 docs/RubyREE)调优.txt，ruby 默认的GC参数都太小，上面的参数是 REE 官方建议的参数
# {
#  RUBY_HEAP_MIN_SLOTS             => '初始堆大小，默认10000，越大需要占用的内存越多'
#  RUBY_HEAP_FREE_MIN              => 'GC后可用的heap slot的最小值，默认4096，如果太小，就会按照下面2个参数分配新栈'
#  RUBY_HEAP_SLOTS_INCREMENT       => '当Ruby需要开辟一片新的堆栈所需的数，默认是10000'
#  RUBY_HEAP_SLOTS_GROWTH_FACTOR   => '当ruby需要新的堆栈的时候， 此参数做为一个乘数被用来计算这片新的堆栈的大小'
#  RUBY_GC_MALLOC_LIMIT            => '允许不触发GC而分配的C数据结构的最大值，默认8000000 byte，设置的太低就会触发垃圾回收'
# }
RUBY_HEAP_MIN_SLOTS=600000
RUBY_FREE_MIN=200000
RUBY_GC_MALLOC_LIMIT=60000000
export RUBY_HEAP_MIN_SLOTS RUBY_FREE_MIN RUBY_GC_MALLOC_LIMIT

pid="log/rainbows.pid"

case "$1" in
  start)
    bundle exec rainbows -c config/rainbows.rb -E production -D
    ;;
  stop)
    kill -QUIT `cat $pid`
    ;;
  restart)
    $0 stop
    sleep 1
    $0 start
    ;;
  reload)
    kill -USR2 `cat $pid`
    ;;
  force-stop)
    kill -INT `cat $pid`
    ;;
  shutdown-workers)
    kill -WINCH `cat $pid`
    ;;
  increment-worker)
    kill -TTIN `cat $pid`
    ;;
  decrement-worker)
    kill -TTOU `cat $pid`
    ;;
  logrotate)
    kill -USR1 `cat $pid`
    ;;
  *)
    echo $"Usage: $0 {start|stop|restart|reload|force-stop|shutdown-workers|increment-worker|decrement-worker|logrotate|}"
    ;;
esac
