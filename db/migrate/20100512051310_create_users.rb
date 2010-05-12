class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string    :name,                :null => false                
      t.string    :persistence_token,   :null => false                # required
      t.integer   :facebook_uid,        :limit => 8, :null => false
      t.string    :facebook_session_key
      
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
