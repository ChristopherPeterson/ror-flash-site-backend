class CategoriesController < ApplicationController
  #authorize_resource :except => [:index, :show]
  authorize_resource
  #skip_authorization_check :only => [:index, :show]

  cache_sweeper :category_sweeper, :only => [:create, :update, :destroy, :sort, :enable, :disable]
  
  caches_action :index, :layout => false, :cache_path => :index_cache_path.to_proc
  caches_action :show, :layout => false, :cache_path => :show_cache_path.to_proc
  caches_action :about, :layout => false, :cache_path => :about_cache_path.to_proc
  
  # Displays About/Contact page
  def about
    respond_to do |format|
      format.html # about.html.erb
      #format.xml  # about.xml.builder
    end
  end

  # GET /categories
  # GET /categories.xml
  def index
    if can? :update, Category
      if params.has_key? "user_id"
        @categories = Category.find_all_by_user_id(params[:user_id].to_i, :order => 'position')
      else
        @categories = Category.all(:order => 'position')
      end
    else
      @categories = Category.find_all_by_enabled(1, :order => 'position')
    end
    @new_items = Item.find_all_by_enabled(1, :joins => :category, :conditions => {:categories => {:user_id => nil}},
                                           :order => "photo_updated_at DESC", :limit => 17)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  # index.xml.builder
    end
  end
  
  # GET /categories/1
  ## GET /categories/1.xml
  def show
    if can? :update, Category
      @category = Category.find(params[:id])
    else
      @category = Category.find_by_id_and_enabled(params[:id], 1)
    end
    
    respond_to do |format|
      if (@category != nil) && (can? :read, @category)
        format.html # show.html.erb
        #format.xml  { render :xml => @category }
      else
        format.html { redirect_to shop_path } # show.html.erb
        #format.xml  { render :xml => @category }
      end
    end
  end
  
  # GET /categories/new
  ## GET /categories/new.xml
  def new
    @category = Category.new
    
    respond_to do |format|
      format.html { render :action => "new", :layout => false } # new.html.erb
      #format.xml  { render :xml => @category }
    end
  end
  
  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
    
    respond_to do |format|
      format.html { render :action => "edit", :layout => false } # new.html.erb
      #format.xml  { render :xml => @category }
    end
  end
  
  # POST /categories
  # POST /categories.rjs
  def create
    @category = Category.new(params[:category])
    
    #Requery all_categories
    all_categories(true)

    respond_to do |format|
      if @category.save
        flash[:notice] = APP_CONFIG[:category_flash_create]
        format.html { redirect_to shop_path }
        format.js   { render :action => "success" }
      else
        format.html { redirect_to shop_path }
        format.js   # create.rjs
      end
    end
  end
  
  # PUT /categories/1
  # PUT /categories/1.rjs
  def update
    @category = Category.find(params[:id])
    
    respond_to do |format|
      if @category.update_attributes(params[:category])
        flash[:notice] = APP_CONFIG[:category_flash_update]
        format.html { redirect_to category_path(@category) }
        format.js   { render :action => "success" }
      else
        format.html { redirect_to shop_path }
        format.js   # update.rjs
      end
    end
  end
  
  # DELETE /categories/1
  ## DELETE /categories/1.xml
  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    
    #Requery all_categories
    all_categories(true)

    respond_to do |format|
      flash[:notice] = APP_CONFIG[:category_flash_destroy]
      format.html { redirect_to shop_path }
      #format.xml  { head :ok }
    end
  end
  
  # POST /categories/1
  # POST /categories/1.rjs
  def sort
    params[:categories].each_with_index do |id, index|
      #Category.update_all(['position=?', index+1], ['id=?', id])
      Category.update(id, {:position => index+1})
    end
    
    respond_to do |format|
      flash[:notice] = APP_CONFIG[:category_flash_sort]
      format.html { redirect_to shop_path }
      format.js   # sort.rjs
    end
  end
  
  # POST /categories/1/enable
  # POST /categories/1/enable.rjs
  def enable
    @category_id = params[:id]
    Category.update(@category_id, :enabled => 1)
    
    respond_to do |format|
      flash[:notice] = APP_CONFIG[:category_flash_enable]
      format.html { redirect_to shop_path }
      format.js   # enable.rjs
    end
  end  
  
  # POST /categories/1/disable
  # POST /categories/1/disable.rjs
  def disable
    @category_id = params[:id]
    Category.update(@category_id, :enabled => 0)
    
    respond_to do |format|
      flash[:notice] = APP_CONFIG[:category_flash_disable]
      format.html { redirect_to shop_path }
      format.js   # disable.rjs
    end
  end

  private
  def index_cache_path
    if params[:format].eql?("xml")
      "/public/categories.xml"
    elsif current_user != nil
      logger.debug "Index Cache Fetch: /user/#{current_user.id.to_s}/categories"
      "/user/#{current_user.id.to_s}/categories"
    else
      "/public/categories"
    end
  end
  
  def show_cache_path 
    if current_user != nil   
      logger.debug "Show Cache Fetch: /user/#{current_user.id.to_s}/categories/#{params[:id].to_s}"
      "/user/#{current_user.id.to_s}/categories/#{params[:id].to_s}"
    else
      "/public/categories/#{params[:id].to_s}"
    end
  end
 
  def about_cache_path    
    if current_user != nil
      logger.debug "About Cache Fetch: /user/#{current_user.id.to_s}/about"
      "/user/#{current_user.id.to_s}/about"
    else
      "/public/about"
    end
  end 
end
