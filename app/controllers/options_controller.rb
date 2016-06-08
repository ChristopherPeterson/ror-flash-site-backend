class OptionsController < ApplicationController
  #authorize_resource :except => [:index, :show]
  authorize_resource
  #skip_authorization_check :only => [:index, :show]
  
  cache_sweeper :option_sweeper, :only => [:create, :update, :destroy, :sort, :enable, :disable]
  
  caches_action :index, :cache_path => :index_cache_path.to_proc
  caches_action :show, :cache_path => :show_cache_path.to_proc
  
  # GET /options
  ## GET /options.xml
  #def index
  #  if can? :update, Option
  #    @options = Option.all(:order => 'position')
  #  else
  #    @options = Option.find_all_by_enabled(1, :order => 'position')
  #  end
  #  
  #  respond_to do |format|
  #    format.html # index.html.erb
  #    #format.xml  { render :xml => @options }
  #  end
  #end
  
  # GET /options/1
  ## GET /options/1.xml
  #def show
  #  if can? :update, Option
  #    @option = Option.find(params[:id])
  #  else
  #    @option = Option.find_by_id_and_enabled(params[:id], 1)
  #  end
  #  
  #  respond_to do |format|
  #    format.html # show.html.erb
  #    #format.xml  { render :xml => @option }
  #  end
  #end
  
  # GET /options/new
  ## GET /options/new.xml
  def new
    @option = Option.new
    
    respond_to do |format|
      format.html { render :action => "new", :layout => false } # new.html.erb
      #format.xml  { render :xml => @option }
    end
  end
  
  # GET /options/1/edit
  def edit
    @option = Option.find(params[:id])
    
    respond_to do |format|
      format.html { render :action => "edit", :layout => false } # new.html.erb
      #format.xml  { render :xml => @option }
    end
  end
  
  # POST /options
  # POST /options.rjs
  def create
    @option = Option.new(params[:option])
    
    #Requery all_options
    all_options(true)

    respond_to do |format|
      if @option.save
        flash[:notice] = APP_CONFIG[:option_flash_create]
        format.html { redirect_to item_path(@option.item_id) }
        format.js   { render :action => "success" }
      else
        format.html { redirect_to shop_path }
        format.js   # create.rjs
      end
    end
  end
  
  # PUT /options/1
  # PUT /options/1.rjs
  def update
    @option = Option.find(params[:id])
    
    respond_to do |format|
      if @option.update_attributes(params[:option])
        flash[:notice] = APP_CONFIG[:option_flash_update]
        format.html { redirect_to item_path(@option.item_id) }
        format.js   { render :action => "success" }
      else
        format.html { redirect_to shop_path }
        format.js   # update.rjs
      end
    end
  end
  
  # DELETE /options/1
  ## DELETE /options/1.xml
  def destroy
    @option = Option.find(params[:id])
    @option.destroy
    
    #Requery all_options
    all_options(true)

    respond_to do |format|
      flash[:notice] = APP_CONFIG[:option_flash_destroy]
      format.html { redirect_to item_path(@option.item_id) }
      #format.xml  { head :ok }
    end
  end
  
  # POST /options/1
  # POST /options/1.rjs
  def sort
    if params.has_key? "options"
      params[:options].each_with_index do |id, index|
        #Option.update_all(['position=?', index+1], ['id=?', id])
        Option.update(id, {:position => index+1})
      end
    end
    
    respond_to do |format|
      flash[:notice] = APP_CONFIG[:option_flash_sort]
      format.html { redirect_to shop_path }
      format.js   # sort.rjs
    end
  end
  
  # POST /options/1/enable
  # POST /options/1/enable.rjs
  def enable
    @option_id = params[:id]
    Option.update(@option_id, :enabled => 1)
    
    respond_to do |format|
      flash[:notice] = APP_CONFIG[:option_flash_enable]
      format.html { redirect_to shop_path }
      format.js   # enable.rjs
    end
  end  
  
  # POST /options/1/disable
  # POST /options/1/disable.rjs
  def disable
    @option_id = params[:id]
    Option.update(@option_id, :enabled => 0)
    
    respond_to do |format|
      flash[:notice] = APP_CONFIG[:option_flash_disable]
      format.html { redirect_to shop_path }
      format.js   # disable.rjs
    end
  end

  private
  def index_cache_path    
    if current_user != nil   
      "/user/#{current_user.id.to_s}/options"
    else
      "/public/options"
    end
  end
  
  def show_cache_path 
    if current_user != nil   
      "/user/#{current_user.id.to_s}/options/#{params[:id].to_s}"
    else
      "/public/options/#{params[:id].to_s}"
    end
  end 
end
