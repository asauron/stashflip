class CreateMaps < ActiveRecord::Migration
  def self.up
    create_table :maps do |t|
      t.integer :user_id
      t.string :title
      t.integer :permission
      t.timestamps
    end
  end

  def self.down
    drop_table :maps
  end
end
