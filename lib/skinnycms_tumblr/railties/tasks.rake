namespace :skinnycms_tumblr do
  desc "Force Rebuild the tumblr cache"
  task :force => :environment do
    Admin::PostsController.new.update_cached_posts
  end
end