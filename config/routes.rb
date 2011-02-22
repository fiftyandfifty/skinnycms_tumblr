Rails.application.routes.draw do

  namespace :admin do
    resources :posts
  end

  match 'force_reload_posts', :controller => 'admin/posts', :action => 'force_reload_posts'
end

