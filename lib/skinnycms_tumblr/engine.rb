require "skinnycms_tumblr"
require "rails"
require "action_controller"

module SkinnyCMSTumblr
  class Engine < Rails::Engine
    rake_tasks do
       load "skinnycms_tumblr/railties/tasks.rake"
    end
  end
end
