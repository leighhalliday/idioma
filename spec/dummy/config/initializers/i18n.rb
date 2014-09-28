$redis = Redis.new(:host => 'localhost', :port => 6379)
I18n.backend = I18n::Backend::KeyValue.new($redis)