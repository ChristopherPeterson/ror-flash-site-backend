class ChangeRolesMaskInUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.change :roles_mask, :integer, :default => 0
    end
  end

  def self.down
    change_table :users do |t|
      t.change :roles_mask, :integer, :default => nil
    end
  end
end
