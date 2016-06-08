class Option < ActiveRecord::Base
  belongs_to :item
  acts_as_list
  
  validates_presence_of :details
  validates_numericality_of :price, :greater_than_or_equal_to => 0
  validates_numericality_of :quantity, :only_integer => true, :greater_than_or_equal_to => 0
  
  def details_with_price
    "#{details}  ($%.2f)" % price
  end
end
