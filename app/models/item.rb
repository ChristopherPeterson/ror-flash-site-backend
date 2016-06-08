class Item < ActiveRecord::Base
  belongs_to :category
  has_many :options,
           :order     => 'position', 
           :dependent => :destroy
           
  acts_as_list
  
  has_attached_file :photo, :styles => { :full => "1920x1024>", :medium => "640x480>", :thumb => "320x240#" }
	
	validates_presence_of :name
	#validates_presence_of :description
  validates_attachment_presence :photo
	validates_attachment_size :photo
	validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']  
end
