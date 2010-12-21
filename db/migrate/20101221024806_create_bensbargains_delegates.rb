class CreateBensbargainsDelegates < ActiveRecord::Migration
  def self.up
    create_table :bensbargains_delegates do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :bensbargains_delegates
  end
end
