class CartsController < ApplicationController
  authorize_resource :except => [:show]
  skip_authorization_check :only => [:show]
  
  #skip_authorization_check :only => [:show]
  #caches_action :index, :show
  #cache_sweeper :cart_sweeper
  
  # GET /carts
  ## GET /carts.xml
  def index
    if params.has_key? "user_id"
      @carts = Cart.find_all_by_user_id(params[:user_id].to_i, :order => 'created_at DESC')
    else
      @carts = Cart.all(:order => 'created_at DESC')
    end
    
    respond_to do |format|
      format.html # index.html.erb
      #format.xml  { render :xml => @carts }
    end
  end
  
  # GET /carts/1
  ## GET /carts/1.xml
  def show
    @cart = current_cart
    
    respond_to do |format|
      format.html # show.html.erb
      #format.xml  { render :xml => @cart }
    end
  end
  
  # GET /carts/new
  ## GET /carts/new.xml
  def new
    # Remove the cart_id from the session
    session[:cart_id] = nil
    
    respond_to do |format|
      format.html { redirect_to carts_url }
      #format.xml  { render :xml => @cart }
    end
  end

  # DELETE /carts/1
  # DELETE /carts/1.js
  def destroy
    @cart = Cart.find(params[:id])
    @cart.destroy
    
    respond_to do |format|
      flash[:notice] = "Successfully deleted cart."
      format.html { redirect_to carts_url }
      format.js   # destroy.rjs
    end
  end
  
  # GET /galleries/1/sent
  # GET /galleries/1/sent.rjs
  def sent
    @cart = Cart.find(params[:id])
    @cart.update_attribute(:sent_at, Time.now)
    @sent_at = "Order marked shipped: #{Time.now.strftime("%m/%d/%Y %I:%M%p")}."
    
    respond_to do |format|
      flash[:notice] = @sent_at
      format.html { redirect_to carts_url }
      format.js   # sent.rjs
    end
  end

  # GET /galleries/1/delivered
  # GET /galleries/1/delivered.rjs
  def delivered
    @cart = Cart.find(params[:id])
    @cart.update_attribute(:delivered_at, Time.now)
    @delivered_at = "Order marked delivered: #{Time.now.strftime("%m/%d/%Y %I:%M%p")}."
    
    respond_to do |format|
      flash[:notice] = @delivered_at
      format.html { redirect_to carts_url }
      format.js   # delivered.rjs
    end
  end
end
