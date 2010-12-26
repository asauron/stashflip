class CreateDeals < ActiveRecord::Migration
  def self.up
    create_table :deals do |t|
      t.string :name
      t.text :description
      t.string :guid
      t.string :source
      t.string :buy_link
      t.datetime :publish_date
      t.string :stashflip_status
      t.string :permadeal
      t.timestamps
    end
  end

  def self.down
    drop_table :deals
  end
end
