require 'rails/generators'

class SkinnycmsTumblrGenerator < Rails::Generators::Base

  desc "Installing SKINNYCMS_TUMBLR extension to application"

  def install
    puts self.class.start_description

    Dir.chdir("#{RAILS_ROOT}/")
    gemfile = IO.read('Gemfile')
    run "gem install tumblr-api -v '0.1.4'" if gemfile.scan("tumblr-api").size < 1
    insert_into_file "Gemfile", "gem 'tumblr-api', '0.1.4', :require => 'tumblr'\n\n", :before => "gem 'skinnycms'" if gemfile.scan("tumblr-api").size < 1
    run "bundle install"
    run "rails generate skinnycms_tumblr_migrations"

    puts self.class.end_description
  end

  class << self
    def start_description
        <<-DESCRIPTION
*******************************************************************

  Installing SKINNYCMS_TUMBLR extension ...

*******************************************************************
        DESCRIPTION
    end

    def end_description
        <<-DESCRIPTION
*******************************************************************

  SKINNYCMS_TUMBLR successfully installed!

*******************************************************************
        DESCRIPTION
    end
  end
end
