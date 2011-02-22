require 'rails/generators'
require 'rails/generators/migration'

class SkinnycmsTumblrMigrationsGenerator < Rails::Generators::Base

  include Rails::Generators::Migration

  desc "Creating migration to application"

  def create_migration
    Dir.mkdir("db/migrate") if Dir["db/migrate"].blank?
    Dir.chdir("#{RAILS_ROOT}/db/migrate")

    cache_tumblr_post_columns = {
                    :tumblr_post_id => "string",
                    :title => "string",
                    :desc => "text",
                    :url => "string",
                    :reblog_key => "string",
                    :post_type => "string",
                    :post_date => "datetime",
                    :incomplete => "boolean"
                    }

    cache_tumblr_post_indexes = [
                    "index_tumblr_posts_on_complete_id"
                    ]

    begin
      cache_tumblr_post_app_columns = ActiveRecord::Base::CacheTumblrPost.column_names
      cache_tumblr_post_app_indexes = ActiveRecord::Base.connection.indexes("cache_tumblr_posts")
      self.class.define_migration("cache_tumblr_posts", cache_tumblr_post_columns, cache_tumblr_post_app_columns, cache_tumblr_post_indexes, cache_tumblr_post_app_indexes)
    rescue
      self.class.check_migration_file("*create_cache_tumblr_posts*", "create_cache_tumblr_posts.rb")
    end
    
    rake("db:migrate")
    remove_file Dir.glob(@@migration).first if File.exist?(@@migration)
  end

  class << self
    def generator
      SkinnycmsTumblrMigrationsGenerator.new
    end

    def source_root
      @source_root ||= File.join(File.dirname(__FILE__), 'migrations')
    end

    def next_migration_number(dirname)
      if ActiveRecord::Base.timestamped_migrations
        Time.new.utc.strftime("%Y%m%d%H%M%S")
      else
        "%.3d" % (current_migration_number(dirname) + 1)
      end
    end

    def define_migration(table_name, engine_columns, application_columns, engine_indexes, application_indexes)
        migration_columns = {}
        migration_indexes = []
        application_indexes_names = []

        application_indexes.each do |value|
          application_indexes_names << value.name
        end

        engine_columns.each do |key, value|
          migration_columns["#{key}"] = value if !application_columns.include?(key.to_s)
        end

        engine_indexes.each do |value|
          migration_indexes << value if !application_indexes_names.include?(value.to_s)
        end

        if check_migration_file("*add_skinnycms_fields_to_#{table_name}.rb*", "add_skinnycms_fields_to_#{table_name}.rb")
          old_migration = Dir.glob("*add_skinnycms_fields_to_#{table_name}.rb*").first
          generator.remove_file old_migration
          @@migration = generator.migration_template "add_skinnycms_fields_to_#{table_name}.rb", "add_skinnycms_fields_to_#{table_name}.rb"
        end

        exist_migration = Dir.glob("*add_skinnycms_fields_to_#{table_name}.rb*").first

        migration_columns.each do |key, value|
          generator.gsub_file "#{exist_migration}", "# add_column :#{table_name}, :#{key}, :#{value}", "add_column :#{table_name}, :#{key}, :#{value}"
          generator.gsub_file "#{exist_migration}", "# remove_column :#{table_name}, :#{key}", "remove_column :#{table_name}, :#{key}"
        end

        migration_indexes.each do |value|
          file = File.readlines(exist_migration)
          lines = file
          i = 0
          lines.each do |line|
            file[i] = "     " + line[6..-1] if line.include?(value)
            i += 1
          end
          real_file = File.open(exist_migration, "w")
          real_file.write(file)
          real_file.close
        end

        if migration_columns.blank? && migration_indexes.blank?
          generator.remove_file exist_migration 
          generator.say "You already have all required #{table_name} fields!", :green
        end
    end

    def check_migration_file(search_condition, migration_name)
      if Dir.glob(search_condition).count < 1
        begin
          @@migration = generator.migration_template migration_name, migration_name
        rescue
        end
      else
        return true
      end
    end
  end
end
