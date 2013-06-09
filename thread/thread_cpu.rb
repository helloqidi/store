# encoding: utf-8
# 测试最佳线程数量：CPU处理
# Your app may be IO-bound in some places, and CPU-bound in other places. Your app may not be bound by CPU or IO, it may be memory-bound, or simply not maximizing resources in any way.Run your code with different thread counts, measure the results, and then decide. Without measuring, you may never find the 'right' answer.

require 'benchmark'
require 'bigdecimal'
require 'bigdecimal/math'

DIGITS = 10_000
ITERATIONS = 24
def calculate_pi(thread_count)
  threads = []
  thread_count.times do
    threads << Thread.new do
      iterations_per_thread = ITERATIONS / thread_count
      iterations_per_thread.times do
        BigMath.PI(DIGITS)
      end
    end
  end
  threads.each(&:join)
end

Benchmark.bm(20) do |bm|
  [1, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24].each do |thread_count|
      bm.report("with #{thread_count} threads") do
        calculate_pi(thread_count)
      end
    end
end
