$redis = Redis.new(:host => "127.0.0.1", :port => 6379)

at_exit do
  $redis.quit
end
