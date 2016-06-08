class Ability
  include CanCan::Ability
  
  def initialize(user)
    user ||= User.new #guest user
    
    if (user.role?(:admin) || user.role?(:moderator))
      can :manage, :all
    else
      # Can Show and Index Category
      can :read, Category, :enabled => 1, :user_id => [nil, user.id]
      can :about, Category
      # Can Show and Index Item
      can :read, Item, :enabled => 1, :category => {:user_id => [nil, user.id]}
      # Can Show and Index Option
      can :read, Option, :enabled => 1, :item => {:category => {:user_id => [nil, user.id]}}
      # Can Show Cart
      can :show, Cart
      # Can Create, Edit, Update, and Destroy LineItem (From Cart)
      can [:create, :edit, :update, :destroy], LineItem
      # Can Create PaymentNotification
      can :create, PaymentNotification
      
      # Can Show and Index Post
      can :read, Post
      
      # Can Create and Destroy User
      # can :manage, User
      # Can Create and Destroy UserSession
      can :manage, UserSession
    end
  end
end