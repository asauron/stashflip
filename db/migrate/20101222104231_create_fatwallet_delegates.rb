class CreateFatwalletDelegates < ActiveRecord::Migration
  def self.up
    create_table :fatwallet_delegates do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :fatwallet_delegates
  end
end
