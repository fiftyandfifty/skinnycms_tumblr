class CacheTumblrPost < ActiveRecord::Base
  validates :title, :desc, :presence => true
end