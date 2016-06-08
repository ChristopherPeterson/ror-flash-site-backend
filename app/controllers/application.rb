# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  helper_method :current_user, :current_categories
  check_authorization

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '526292d4095d0fd8135a9aa118f5956e'

  # See ActionController::Base for details
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password").
  filter_parameter_logging :password

  def current_cart
    if session[:cart_id]
      @current_cart ||= Cart.find(session[:cart_id])
      session[:cart_id] = nil if @current_cart.purchased_at
    end
    if session[:cart_id].nil?
      @current_cart = Cart.create!
      session[:cart_id] = @current_cart.id
    end
    if current_user && @current_cart.user_id == nil
      @current_cart.update_attributes({:user_id => current_user.id})
    end

    @current_cart
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to login_path
  end

  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def current_categories
    return @categories if defined?(@categories)
    if can? :update, Category
      @categories = Category.all(:order => 'position')
    else
      @categories = Category.find_all_by_enabled(1, :order => 'position')
    end
  end

  def all_users(refresh = false)
    if refresh
      logger.debug "Refreshing all_users"
    end
    return @all_users if (defined?(@all_users) and refresh == false)
    @all_users = User.all(:select => :id)
  end

  def all_categories(refresh = false)
    if refresh
      logger.debug "Refreshing all_categories"
    end
    return @all_categories if (defined?(@all_categories) and refresh == false)
    @all_categories = Category.all(:select => :id)
  end

  def all_items(refresh = false)
    if refresh
      logger.debug "Refreshing all_items"
    end
    return @all_items if (defined?(@all_items) and refresh == false)
    @all_items = Item.all(:select => :id)
  end

  def all_options(refresh = false)
    if refresh
      logger.debug "Refreshing all_options"
    end
    return @all_options if (defined?(@all_options) and refresh == false)
    @all_options = Option.all(:select => :id)
  end
end

