resque_config = YAML.load_file("#{Rails.root}/config/resque.yml")
Resque.redis = resque_config[Rails.env]


Resque.before_fork do

  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end
end

Resque.after_fork do
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end



