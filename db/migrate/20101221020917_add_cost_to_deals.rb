class AddCostToDeals < ActiveRecord::Migration
  def self.up
  	add_column :deals, :cost, :decimal, :default => 0, :precision => 6, :scale => 2
  end

  def self.down
  	remove_column :deals, :cost
  end
end
