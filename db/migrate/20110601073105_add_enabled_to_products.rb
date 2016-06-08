class AddEnabledToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :enabled, :integer, :default => 0
  end

  def self.down
    remove_column :products, :enabled
  end
end
