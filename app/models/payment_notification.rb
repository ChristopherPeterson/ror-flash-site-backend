class PaymentNotification < ActiveRecord::Base
  belongs_to :cart
  serialize :params
  after_create :mark_cart_as_purchased
  
  private
  
  def mark_cart_as_purchased
    #if status == "Completed" && params[:secret] == APP_CONFIG[:paypal_secret] &&
    #    params[:receiver_email] == APP_CONFIG[:paypal_email] &&
    #    params[:mc_gross] == cart.total_price.to_s && params[:mc_currency] == "USD"
    #  cart.update_attribute(:purchased_at, Time.now)
    #end
    if status == "Completed" && params[:secret] == APP_CONFIG[:paypal_secret]
      # Mark date of purchase through PayPal
      cart.update_attribute(:purchased_at, Time.now)
      
      # Subtract Cart's LineItem quantities from Option quantities
      for line_item in cart.line_items
        if line_item.option.quantity > 0
          line_item.option.update_attribute(:quantity, line_item.option.quantity - 1)
        end
      end
    end
  end
end
