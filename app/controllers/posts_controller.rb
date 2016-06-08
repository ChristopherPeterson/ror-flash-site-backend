class PostsController < ApplicationController
  #authorize_resource :except => [:index, :show]
  authorize_resource
  #skip_authorization_check :only => [:index, :show]
  
  cache_sweeper :post_sweeper, :only => [:create, :update, :destroy]
  
  caches_action :index, :cache_path => :index_cache_path.to_proc
  caches_action :show, :cache_path => :show_cache_path.to_proc
  
  # GET /posts
  # GET /posts.xml
  def index
    @posts = Post.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  # GET /posts/1
  ## GET /posts/1.xml
  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.find(:all)
    @new_comment = @post.comments.new
    @post.comments.pop

    respond_to do |format|
      format.html # show.html.erb
      #format.xml  { render :xml => @post }
    end
  end

  # GET /posts/new
  ## GET /posts/new.xml
  def new
    @post = Post.new

    respond_to do |format|
      format.html { render :action => "new", :layout => false } # new.html.erb
      #format.xml  { render :xml => @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
    
    respond_to do |format|
      format.html { render :action => "edit", :layout => false } # edit.html.erb
      #format.xml  { render :xml => @post }
    end
  end

  # POST /posts
  # POST /posts.rjs
  def create
    @post = Post.new(params[:post])

    respond_to do |format|
      if @post.save
        flash[:notice] = APP_CONFIG[:post_flash_create]
        format.html { redirect_to(@post) }
        format.js   { render :action => "success" }
      else
        format.html { redirect_to shop_path }
        format.js   # create.rjs
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.rjs
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        flash[:notice] = APP_CONFIG[:post_flash_update]
        format.html { redirect_to(@post) }
        format.js   { render :action => "success" }
      else
        format.html { redirect_to shop_path }
        format.js   # update.rjs
      end
    end
  end

  # DELETE /posts/1
  ## DELETE /posts/1.xml
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      flash[:notice] = APP_CONFIG[:post_flash_destroy]
      format.html { redirect_to shop_path }
      #format.xml  { head :ok }
    end
  end

  private
  def index_cache_path    
    if current_user != nil   
      "/user/#{current_user.id.to_s}/posts"
    else
      "/public/posts"
    end
  end
  
  def show_cache_path 
    if current_user != nil   
      "/user/#{current_user.id.to_s}/posts/#{params[:id].to_s}"
    else
      "/public/posts/#{params[:id].to_s}"
    end
  end
end
