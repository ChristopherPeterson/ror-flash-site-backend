class Change < ActiveRecord::Migration
  def self.up
    rename_table :products, :items
  end

  def self.down
    rename_table :items, :products
  end
end
