class UsersController < ApplicationController
  authorize_resource
  protect_from_forgery :only => [:create, :update]
  
  # GET /users
  ## GET /users.xml
  def index
    @users = User.all
    
    respond_to do |format|
      format.html # index.html.erb
      #format.xml  # index.xml.builder
    end
  end
  
  # GET /users/new
  ## GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html { render :action => "new", :layout => false } # new.html.erb
      #format.xml  { render :xml => @user }
    end
  end
  
  # GET /users/1/edit
  def edit
    #@user = current_user
    @user = User.find(params[:id])
    
    respond_to do |format|
      format.html { render :action => "edit", :layout => false } # edit.html.erb
      #format.xml  { render :xml => @user }
    end
  end
  
  # POST /users
  ## POST /users.xml
  def create
    @user = User.new(params[:user])
    
    #Requery all_users
    all_users(true)

    respond_to do |format|
      if @user.save
        flash[:notice] = APP_CONFIG[:user_flash_create]
        format.html { redirect_to(users_path) }
        #format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { redirect_to(shop_path) }
        #format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /users/1
  ## PUT /users/1.xml
  def update
    #@user = current_user
    @user = User.find(params[:id])
    
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = APP_CONFIG[:user_flash_update]
        format.html { redirect_to(users_path) }
        #format.xml  { head :ok }
      else
        format.html { redirect_to(shop_path) }
        #format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /users/1
  ## DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    #Requery all_users
    all_users(true)

    respond_to do |format|
      flash[:notice] = APP_CONFIG[:user_flash_destroy]
      format.html { redirect_to users_path }
      #format.xml  { head :ok }
    end
  end
end
