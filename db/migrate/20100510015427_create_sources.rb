class CreateSources < ActiveRecord::Migration
  def self.up
    create_table :sources do |t|
      t.string :url
      t.string :name
      t.string :icon_filename

      t.timestamps
    end
  end

  def self.down
    drop_table :sources
  end
end
