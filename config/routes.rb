ActionController::Routing::Routes.draw do |map|
  map.login "login.:format", :controller => "user_sessions", :action => "new"
  map.login "login", :controller => "user_sessions", :action => "neww"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"
  map.shop "shop", :controller => "categories", :action => "index"

  map.about "about", :controller => "categories", :action => "about"

  map.resources :user_sessions
  map.resources :users, :has_many => [:comments]
  
  map.resources :payment_notifications

  map.current_cart 'cart', :controller => 'carts', :action => 'show', :id => 'current'
  
  map.resources :line_items
  map.resources :carts,
                :member => {:sent => :get, :delivered => :get}
                
  map.resources :options, 
                :member => {:enable => :get, :disable => :get}, 
                :collection => {:sort => :post}
                
  map.resources :items, 
                :member => {:enable => :get, :disable => :get}, 
                :collection => {:sort => :post}
                
  map.resources :categories, 
                :member => {:enable => :get, :disable => :get}, 
                :collection => {:sort => :post, :about => :get}
                
  map.resources :posts
  map.resources :comments, :only => [:edit, :create, :update, :destroy]

  map.root :categories
end
