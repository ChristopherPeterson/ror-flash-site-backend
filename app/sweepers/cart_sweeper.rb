class CartSweeper < ActionController::Caching::Sweeper
  observe Cart # This sweeper is going to keep an eye on the cart model
 
  # If our sweeper detects that a Item was created call this
  def after_create(cart)
          expire_cache_for(cart)
  end
 
  # If our sweeper detects that a Item was updated call this
  def after_update(cart)
          expire_cache_for(cart)
  end
 
  # If our sweeper detects that a Item was deleted call this
  def after_destroy(cart)
          expire_cache_for(cart)
  end
 
  # If our sweeper detects that a Item was updated call this
  def after_sent(cart)
          expire_cache_for(cart)
  end
 
  # If our sweeper detects that a Item was updated call this
  def after_delivered(cart)
          expire_cache_for(cart)
  end
 
  private
  def expire_cache_for(cart)
    # Expire the index page now that we added a new gallery
    expire_action(:controller => 'carts', :action => 'index')
    expire_action(:controller => 'carts', :action => 'show', :id => cart.id)
 
  end
end