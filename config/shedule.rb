every 30.minutes do
  rake "skinnycms_tumblr:force", :environment => "production", :output => "/var/log/rails_cron_tasks.log"
end