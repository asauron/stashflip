class CreateDeals < ActiveRecord::Migration
  def self.up
    create_table :deals do |t|
      t.string :title
      t.string :description
	  t.decimal :price, :default => 0, :precision => 8, :scale => 2
      t.timestamps
    end
  end

  def self.down
    drop_table :deals
  end
end
