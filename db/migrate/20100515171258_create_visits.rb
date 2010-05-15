class CreateVisits < ActiveRecord::Migration
  def self.up
    create_table :visits do |t|
      t.integer :user_id, :null => false
      t.integer :place_id, :null => false
      t.boolean :pending, :default => true
      t.boolean :visited, :default => false
      t.boolean :shared, :default => false
      
      t.timestamps
    end
    
    add_index "visits", ["user_id"], :name => "index_visits_on_user_id"
    add_index "visits", ["place_id"], :name => "index_visits_on_place_id"
  end

  def self.down
    drop_table :visits
  end
end
