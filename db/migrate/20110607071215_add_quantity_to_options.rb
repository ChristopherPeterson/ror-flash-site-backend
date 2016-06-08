class AddQuantityToOptions < ActiveRecord::Migration
  def self.up
    add_column :options, :quantity, :integer
  end

  def self.down
    remove_column :options, :quantity
  end
end
