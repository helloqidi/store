# encoding: utf-8
# 测试最佳线程数量：IO处理
# Your app may be IO-bound in some places, and CPU-bound in other places. Your app may not be bound by CPU or IO, it may be memory-bound, or simply not maximizing resources in any way.Run your code with different thread counts, measure the results, and then decide. Without measuring, you may never find the 'right' answer.

require 'benchmark'
require 'net/http'
URL = URI('http://shijue.me/zone/show_art/517a82b8e744f91b9e00002d')
ITERATIONS = 30
def fetch_url(thread_count)
  threads = []
  thread_count.times do
    threads << Thread.new do
      fetches_per_thread = ITERATIONS / thread_count
      fetches_per_thread.times do
        Net::HTTP.get(URL)
      end
    end
  end
  threads.each(&:join)
end

Benchmark.bm(20) do |bm|
  [1, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24].each do |thread_count|
      bm.report("with #{thread_count} threads") do
        fetch_url(thread_count)
      end
    end
end

