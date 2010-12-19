class CreateGmapDelegates < ActiveRecord::Migration
  def self.up
    create_table :gmap_delegates do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :gmap_delegates
  end
end
