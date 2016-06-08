class ItemsController < ApplicationController
  #authorize_resource :except => [:index, :show]
  authorize_resource
  #skip_authorization_check :only => [:index, :show]

  cache_sweeper :item_sweeper, :only => [:create, :update, :destroy, :sort, :enable, :disable]
  
  caches_action :index, :cache_path => :index_cache_path.to_proc
  caches_action :show, :cache_path => :show_cache_path.to_proc 
  
  # GET /items
  ## GET /items.xml
  #def index
  #  if can? :update, Item
  #    @items = Item.all(:order => 'position')
  #  else
  #    @items = Item.find_all_by_enabled(1, :order => 'position')
  #  end
  #  
  #  respond_to do |format|
  #    format.html # index.html.erb
  #    #format.xml  { render :xml => @items }
  #  end
  #end
  
  # GET /items/1
  ## GET /items/1.xml
  def show
    if can? :update, Item
      @item = Item.find(params[:id])
    else
      @item = Item.find_by_id_and_enabled(params[:id], 1)
    end
    
    respond_to do |format|
      if (@item != nil) && (can? :read, @item)
        format.html # show.html.erb
        #format.xml  { render :xml => @item }
      else
        format.html { redirect_to shop_path }# show.html.erb
        #format.xml  { render :xml => @item }
      end
    end
  end
  
  # GET /items/new
  ## GET /items/new.xml
  def new
    @item = Item.new
    
    respond_to do |format|
      format.html { render :action => "new" } # new.html.erb
      #format.xml  { render :xml => @item }
    end
  end
  
  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
    
    respond_to do |format|
      format.html { render :action => "edit" } # new.html.erb
      #format.xml  { render :xml => @item }
    end
  end
  
  # POST /items
  ## POST /items.xml
  def create
    @item = Item.new(params[:item])
    
    #Requery all_items
    all_items(true)

    respond_to do |format|
      if @item.save
        flash[:notice] = APP_CONFIG[:item_flash_create]
        format.html { redirect_to category_path(@item.category_id) }
        #format.xml  { render :xml => @item, :status => :created, :location => @item }
      else
        format.html { render :action => "new" }
        #format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /items/1
  ## PUT /items/1.xml
  def update
    @item = Item.find(params[:id])
    
    respond_to do |format|
      if @item.update_attributes(params[:item])
        flash[:notice] = APP_CONFIG[:item_flash_update]
        format.html { redirect_to item_path(@item) }
        #format.xml  { head :ok }
      else
        render :action => 'edit'
        #format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /items/1
  # DELETE /items/1.js
  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    
    #Requery all_items
    all_items(true)

    respond_to do |format|
      flash[:notice] = APP_CONFIG[:item_flash_destroy]
      format.html { redirect_to shop_path }
      format.js   # destroy.rjs
    end
  end
  
  # POST /items/1
  # POST /items/1.rjs
  def sort
    if params.keys.grep(/^category_(\d*)_items$/)[0] != nil
        params[params.keys.grep(/^category_(\d*)_items$/)[0]].each_with_index do |id, index|
          #Item.update_all(['position=?', index+1], ['id=?', id])
          Item.update(id, {:position => index+1})
        end 
    elsif (params.has_key? "items")
      params[:items].each_with_index do |id, index|
        #Item.update_all(['position=?', index+1], ['id=?', id])
        Item.update(id, {:position => index+1})
      end
    end
    
    respond_to do |format|
      flash[:notice] = APP_CONFIG[:item_flash_sort]
      format.html { redirect_to shop_path }
      format.js   # sort.rjs
    end
  end
  
  # POST /items/1/enable
  # POST /items/1/enable.rjs
  def enable
    @item_id = params[:id]
    Item.update(@item_id, :enabled => 1)
    
    respond_to do |format|
      flash[:notice] = APP_CONFIG[:item_flash_enable]
      format.html { redirect_to shop_path }
      format.js   # enable.rjs
    end
  end  
  
  # POST /items/1/disable
  # POST /items/1/disable.rjs
  def disable
    @item_id = params[:id]
    Item.update(@item_id, :enabled => 0)
    
    respond_to do |format|
      flash[:notice] = APP_CONFIG[:item_flash_disable]
      format.html { redirect_to shop_path }
      format.js   # disable.rjs
    end
  end

  private
  def index_cache_path    
    if current_user != nil   
      "/user/#{current_user.id.to_s}/items"
    else
      "/public/items"
    end
  end
  
  def show_cache_path 
    if current_user != nil   
      "/user/#{current_user.id.to_s}/items/#{params[:id].to_s}"
    else
      "/public/items/#{params[:id].to_s}"
    end
  end 
end
