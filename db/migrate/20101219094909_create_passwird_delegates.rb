class CreatePasswirdDelegates < ActiveRecord::Migration
  def self.up
    create_table :passwird_delegates do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :passwird_delegates
  end
end
