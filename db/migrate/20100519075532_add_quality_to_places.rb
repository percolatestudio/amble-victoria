class AddQualityToPlaces < ActiveRecord::Migration
  def self.up
    add_column :places, :quality, :decimal,  :precision => 4, :scale => 4
  end

  def self.down
    remove_column :places, :quality
  end
end
