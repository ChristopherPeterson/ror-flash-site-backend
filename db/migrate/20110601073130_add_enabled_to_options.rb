class AddEnabledToOptions < ActiveRecord::Migration
  def self.up
    add_column :options, :enabled, :integer, :default => 0
  end

  def self.down
    remove_column :options, :enabled
  end
end
