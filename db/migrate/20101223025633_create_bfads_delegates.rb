class CreateBfadsDelegates < ActiveRecord::Migration
  def self.up
    create_table :bfads_delegates do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :bfads_delegates
  end
end
