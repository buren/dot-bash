# http://blog.nicksieger.com/articles/2006/04/23/tweaking-irb
ARGV.concat ["--readline", "--prompt-mode", "simple"]

require 'irb/completion'
require 'irb/ext/eval_history'
IRB.conf[:SAVE_HISTORY] = 10_000
IRB.conf[:HISTORY_FILE] = File.expand_path('~/.irb_history')

require 'pp'

# http://ozmm.org/posts/time_in_irb.html
def time(times = 1)
  require 'benchmark'
  ret = nil
  Benchmark.bm { |x| x.report { times.times { ret = yield } } }
  ret
end

def rspec(*args)
  if args.length > 0
    raise(ArgumentError, 'arguments to rspec within IRB session is currently not supported')
  end
  puts `rspec`
end

# list object methods
def local_methods(obj=self)
  (obj.methods - obj.class.superclass.instance_methods).sort
end

# reload this .irbrc
def IRB.reload
  load __FILE__
end
