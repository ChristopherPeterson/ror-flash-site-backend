class LineItem < ActiveRecord::Base
  belongs_to :cart
  belongs_to :option
  
  validates_numericality_of :unit_price, :greater_than_or_equal_to => 0
  validates_numericality_of :quantity, :only_integer => true, :greater_than_or_equal_to => 0
  
  def full_price
    unit_price * quantity
  end
end
