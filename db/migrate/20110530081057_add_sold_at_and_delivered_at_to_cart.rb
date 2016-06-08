class AddSoldAtAndDeliveredAtToCart < ActiveRecord::Migration
  def self.up
    add_column :carts, :sent_at, :datetime
    add_column :carts, :delivered_at, :datetime
  end

  def self.down
    remove_column :carts, :sent_at
    remove_column :carts, :delivered_at
  end
end
