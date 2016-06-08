class ChangeProductIdsToItemIds < ActiveRecord::Migration
  def self.up
    rename_column :options, :product_id, :item_id
  end

  def self.down
    rename_column :options, :item_id, :product_id
  end
end
