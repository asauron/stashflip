class CreateInfos < ActiveRecord::Migration
  def self.up
    create_table :infos do |t|
		t.column :user_id, :integer, :null => false
		t.column :name, :string, :default => ""
		t.column :location, :string, :default => ""
		t.column :bio, :string, :default => ""
		t.column :saved_maps, :string, :default => ""
		t.timestamps
    end
  end

  def self.down
    drop_table :infos
  end
end
