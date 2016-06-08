class UserSessionsController < ApplicationController
  #authorize_resource
  skip_authorization_check :only => [:new, :neww, :create, :destroy]
  
  protect_from_forgery :only => [:create]
  
  # GET /user_sessions/new
  ## GET /user_sessions/new.rjs
  def new
    @user_session = UserSession.new
    
    respond_to do |format|
      format.html { render :action => "new", :layout => false } # new.html.erb
      #format.js   # new.rjs
    end
  end
  
  # GET /user_sessions/neww
  ## GET /user_sessions/new.rjs
  def neww
    @user_session = UserSession.new

    respond_to do |format|
      format.html { render :action => "new" } # new.html.erb
      #format.js   # new.rjs
    end
  end

  # POST /user_sessions
  ## POST /user_sessions.xml
  def create
    @user_session = UserSession.new(params[:user_session])
    
    respond_to do |format|
      if @user_session.save
        flash[:notice] = "Successfully logged in."
        format.html { redirect_to(shop_path) }
        #format.xml  { render :xml => @user_session, :status => :created, :location => @user_session }
      else
        format.html { redirect_to(shop_path) }
        #format.xml  { render :xml => @user_session.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /user_sessions/1
  ## DELETE /user_sessions/1.xml
  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    
    respond_to do |format|
      flash[:notice] = "Successfully logged out."
      format.html { redirect_to(shop_path) }
      #format.xml  { head :ok }
    end
  end
end
