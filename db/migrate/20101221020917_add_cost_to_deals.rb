class AddCostToDeals < ActiveRecord::Migration
  def self.up
  	add_column :deals, :cost, :decimal, :default => 0, :precision => 6, :scale => 2
  	add_column :deals, :cost_retail, :decimal, :default => 0, :precision => 6, :scale => 2
  	add_column :deals, :profit_margin, :decimal, :default => 0, :precision => 6, :scale => 2
  end

  def self.down
  	remove_column :deals, :cost
  	#remove_column :deals, :cost_retail
  	#remove_column :deals, :profit_margin
  end
end
