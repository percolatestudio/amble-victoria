class CreatePlaces < ActiveRecord::Migration
  def self.up
    create_table :places do |t|
      t.string :name
      t.string :location
      t.string :phone
      t.integer :source_id
      t.integer :category_id
      t.integer :primary_image_id
      t.integer :system_quality
      t.integer :user_quality
      t.text :description
      t.decimal :lat, :precision => 15, :scale => 10
      t.decimal :lng, :precision => 15, :scale => 10

      t.timestamps
    end
  end

  def self.down
    drop_table :places
  end
end
