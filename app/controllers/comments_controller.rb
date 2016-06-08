class CommentsController < ApplicationController
  #authorize_resource :except => [:index, :show]
  authorize_resource
  #skip_authorization_check :only => [:index, :show]
  
  #caches_action :index, :show
  #cache_sweeper :comment_sweeper
  
  # GET /comment/1/edit
  def edit
    @comment = Comment.find(params[:id])
    
    respond_to do |format|
      format.html { render :action => "edit", :layout => false } # edit.html.erb
      #format.xml  { render :xml => @post }
    end
  end

  # POST /comments
  # POST /comments.rjs
  def create
    @commentable_type = params[:commentable][:commentable]
    @commentable_id = params[:commentable][:commentable_id]
    # Get the object that you want to comment
    @commentable = Comment.find_commentable(@commentable_type, @commentable_id)
  
    # Create a comment with the user submitted content
    @comment = Comment.new(params[:comment])
    # Assign this comment to the logged in user
    if current_user
      @comment.user_id = current_user.id
    end
  
    # Add the comment
    @commentable.comments << @comment

    respond_to do |format|
      if @comment.save
        flash[:notice] = APP_CONFIG[:comment_flash_create]
        format.html { redirect_to @commentable }
        format.js   { render :action => "success" }
      else
        format.html { redirect_to @commentable }
        format.js   # create.rjs
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.rjs
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        flash[:notice] = APP_CONFIG[:comment_flash_update]
        format.html { redirect_to @comment.commentable }
        format.js   { render :action => "success" }
      else
        format.html { redirect_to @comment.commentable }
        format.js   # update.rjs
      end
    end
  end

  # DELETE /comments/1
  ## DELETE /comments/1.xml
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      flash[:notice] = APP_CONFIG[:comment_flash_destroy]
      format.html { redirect_to @comment.commentable }
      #format.xml  { head :ok }
    end
  end
end
