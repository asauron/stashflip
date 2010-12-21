class CreateDealAdapters < ActiveRecord::Migration
  def self.up
    create_table :deal_adapters do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :deal_adapters
  end
end
