class LineItemsController < ApplicationController
  #authorize_resource
  skip_authorization_check :only => [:create, :edit, :update, :destroy]
  
  # POST /line_items
  # POST /line_items/enable.rjs
  def create
    if params[:line_item].has_key? "option_id"
      if !params[:line_item][:option_id].eql?("")
        @option = Option.find(params[:line_item][:option_id])
        @line_item = LineItem.find_by_cart_id_and_option_id(current_cart.id, @option.id)
        if @line_item == nil
          # Didn't find existing line_item, create new one
          @line_item = LineItem.create!(:cart => current_cart, :option => @option, :quantity => ((params.has_key? "quantity") ? params[:quantity].to_i : 1), :unit_price => @option.price)
          flash[:notice] = "Added #{@line_item.quantity} #{@option.item.name} - #{@option.details} to cart."
        else
          #Found existing line_item, increment quantity
          @line_item.update_attribute(:quantity, @line_item.quantity + ((params.has_key? "quantity") ? params[:quantity].to_i : 1))
          flash[:notice] = "Updated #{@option.item.name} - #{@option.details} in cart to #{@line_item.quantity}."
        end
      end
    end
    
    respond_to do |format|
      format.html { redirect_to current_cart_url }
      format.js   # create.rjs
    end
  end
  
  # GET /line_items/1/edit
  # GET /line_items/1/edit.js
  def edit
    @line_item = LineItem.find(params[:id])
    
    respond_to do |format|
      format.html # edit.html.erb
      format.js   # edit.rjs
    end
  end
  
  # PUT /line_items/1
  # PUT /line_items/1.js
  def update
    @cart = current_cart
    @line_item = LineItem.find(params[:id])
    
    respond_to do |format|
      if @line_item.update_attributes(params[:line_item])
        flash[:notice] = "Successfully updated item."
        format.html { redirect_to(current_cart_url) }
        format.js   # update.rjs
      else
        format.html { redirect_to current_cart_url }
        format.js   # update.rjs
      end
    end
  end
  
  # DELETE /line_items/1
  # DELETE /line_items/1.js
  def destroy
    @cart = current_cart
    @line_item = LineItem.find(params[:id])
    @line_item.destroy
    
    respond_to do |format|
      flash[:notice] = "Successfully removed item from cart."
      format.html { redirect_to(current_cart_url) }
      format.js  # destroy.rjs
    end
  end
end
