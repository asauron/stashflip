class CreateEventfulDelegates < ActiveRecord::Migration
  def self.up
    create_table :eventful_delegates do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :eventful_delegates
  end
end
