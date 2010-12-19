class CreateYelpDelegates < ActiveRecord::Migration
  def self.up
    create_table :yelp_delegates do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :yelp_delegates
  end
end
