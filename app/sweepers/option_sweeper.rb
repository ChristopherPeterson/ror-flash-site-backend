class OptionSweeper < ActionController::Caching::Sweeper
  observe Option # This sweeper is going to keep an eye on the Item model
 
  def after_save(option)
    expire_cache_for(option)
  end
  
  # If our sweeper detects that a Item was created call this
  def after_create(option)
    expire_cache_for(option)
  end
 
  # If our sweeper detects that a Item was updated call this
  def after_update(option)
    expire_cache_for(option)
  end
 
  # If our sweeper detects that a Item was deleted call this
  def after_destroy(option)
    expire_cache_for(option)
  end
  
  def after_sort(option)
    expire_cache_for(option)
  end
  
  def after_enable(option)
    expire_cache_for(option)
  end
  
  def after_disable(option)
    expire_cache_for(option)
  end
 
  private
  def expire_cache_for(category)
    # Expire the show page now that we made a change
    for cat in all_categories do
      for user in all_users do
        logger.debug "Show Cache Flush: /user/#{user.id.to_s}/categories/#{cat.id.to_s}"
        expire_action "/user/#{user.id.to_s}/categories/#{cat.id.to_s}"
      end

      expire_action "/public/categories/#{cat.id.to_s}"
    end

    for itm in all_items do
      for user in all_users do
        logger.debug "Show Cache Flush: /user/#{user.id.to_s}/items/#{itm.id.to_s}"
        expire_action "/user/#{user.id.to_s}/items/#{itm.id.to_s}"
      end

      expire_action "/public/items/#{itm.id.to_s}"
    end

    for opt in all_categories do
      for user in all_users do
        logger.debug "Show Cache Flush: /user/#{user.id.to_s}/options/#{opt.id.to_s}"
        expire_action "/user/#{user.id.to_s}/options/#{opt.id.to_s}"
      end

      expire_action "/public/options/#{opt.id.to_s}"
    end

    ####
    # Expire the about page now that we made a change
    for user in all_users do
      logger.debug "About Cache Flush: /user/#{user.id.to_s}/about"
      expire_action "/user/#{user.id.to_s}/about"
    end
    expire_action "/public/about"

    ####
    # Expire the index page now that we made a change
    for user in all_users do
      logger.debug "Index Cache Flush: /user/#{user.id.to_s}/categories"
      expire_action "/user/#{user.id.to_s}/categories"
    end
    expire_action "/public/categories"
    expire_action "/public/categories.xml"

    for user in all_users do
      logger.debug "Index Cache Flush: /user/#{user.id.to_s}/items"
      expire_action "/user/#{user.id.to_s}/items"
    end
    expire_action "/public/items"

    for user in all_users do
      logger.debug "Index Cache Flush: /user/#{user.id.to_s}/options"
      expire_action "/user/#{user.id.to_s}/options"
    end
    expire_action "/public/options"

  end
end