class CreateWebpages < ActiveRecord::Migration
  def self.up
    create_table :webpages do |t|
      t.integer :source_id
      t.integer :place_id
      t.string :url

      t.timestamps
    end
  end

  def self.down
    drop_table :webpages
  end
end
