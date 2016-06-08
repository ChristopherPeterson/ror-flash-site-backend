class PostSweeper < ActionController::Caching::Sweeper
  observe Post # This sweeper is going to keep an eye on the Post model
 
  def after_save(post)
    expire_cache_for(post)
  end
  
  # If our sweeper detects that a Item was created call this
  def after_create(post)
          expire_cache_for(post)
  end
 
  # If our sweeper detects that a Item was updated call this
  def after_update(post)
          expire_cache_for(post)
  end
 
  # If our sweeper detects that a Item was deleted call this
  def after_destroy(post)
          expire_cache_for(post)
  end
 
  private
  def expire_cache_for(post)
    # Expire the show page now that we made a change
    for user in all_users do
      expire_action "/user/#{user.id.to_s}/posts/#{post.id.to_s}"
    end
    expire_action "/public/posts/#{post.id.to_s}"
    
    # Expire the index page now that we made a change
    for user in all_users do
      expire_action "/user/#{user.id.to_s}/posts"
    end
    expire_action "/public/posts"
 
  end
end