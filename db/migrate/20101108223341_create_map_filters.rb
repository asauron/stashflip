class CreateMapFilters < ActiveRecord::Migration
  def self.up
    create_table :map_filters do |t|
      t.integer :map_id
      t.string :query
      t.string :location
      t.string :category
      t.string :add_nodes
      t.string :exclude_nodes
	  t.integer :num_ratings_weight
      t.integer :avg_rating_weight
      t.integer :cheapness_weight      
      t.timestamps
    end
  end

  def self.down
    drop_table :map_filters
  end
end
