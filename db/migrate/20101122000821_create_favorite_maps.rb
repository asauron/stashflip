class CreateFavoriteMaps < ActiveRecord::Migration
  def self.up
    create_table :favorite_maps do |t|
      t.integer :user_id
      t.integer :map_id
      t.timestamps
    end
  end

  def self.down
    drop_table :favorite_maps
  end
end
