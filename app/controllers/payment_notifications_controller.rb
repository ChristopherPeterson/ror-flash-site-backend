class PaymentNotificationsController < ApplicationController
  skip_authorization_check :only => [:create]
  protect_from_forgery :except => [:create]
  
  # POST /payment_notifications
  ## POST /payment_notifications.xml
  def create
    PaymentNotification.create!(:params => params, :cart_id => params[:invoice], :status => params[:payment_status], :transaction_id => params[:txn_id])
    render :nothing => true
  end
end
