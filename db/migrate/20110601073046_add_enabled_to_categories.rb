class AddEnabledToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :enabled, :integer, :default => 0
  end

  def self.down
    remove_column :categories, :enabled
  end
end
