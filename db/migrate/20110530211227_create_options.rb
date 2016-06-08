class CreateOptions < ActiveRecord::Migration
  def self.up
    create_table :options do |t|
      t.belongs_to :product
      t.text :details
      t.decimal :price
      t.timestamps
    end
  end

  def self.down
    drop_table :options
  end
end
