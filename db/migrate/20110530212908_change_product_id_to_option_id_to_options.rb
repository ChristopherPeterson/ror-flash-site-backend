class ChangeProductIdToOptionIdToOptions < ActiveRecord::Migration
  def self.up
    remove_column :line_items, :product_id
    add_column :line_items, :option_id, :integer
  end

  def self.down
    add_column :line_items, :product_id, :integer
    remove_column :line_items, :option_id
  end
end
