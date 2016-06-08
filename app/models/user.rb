class User < ActiveRecord::Base
  acts_as_authentic
  has_many :categories,
           :order     => 'position', 
           :dependent => :destroy
  has_many :carts
  has_many :comments

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :roles, :roles_mask

  # CanCan Roles
  ROLES = %w[admin moderator author banned]
  
  validates_presence_of :username
  validates_format_of :email, :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/

  
  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end
  
  def roles
    ROLES.reject do |r|
      ((roles_mask || 0) & 2**ROLES.index(r)).zero?
    end
  end
  
  def role?(role)
    roles.include?(role.to_s)
  end
end
