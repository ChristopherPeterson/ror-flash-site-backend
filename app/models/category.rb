class Category < ActiveRecord::Base
  belongs_to :user
  has_many :items,
           :order     => 'position', 
           :dependent => :destroy
  
  validates_presence_of :name
end
