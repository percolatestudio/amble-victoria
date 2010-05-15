class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string    :name,                :null => false                
      t.string    :persistence_token
      t.integer   :facebook_uid,        :limit => 8, :null => false
      t.string    :facebook_session_key
      
      t.timestamps
    end
    
    add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"
    add_index "users", ["facebook_uid"], :name => "index_users_on_facebook_uid"    
  end

  def self.down
    drop_table :users
  end
end
