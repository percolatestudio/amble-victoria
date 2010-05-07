class AddImageFileNameToPlace < ActiveRecord::Migration
  def self.up
    add_column :places, :image_file_name, :string
  end

  def self.down
    remove_column :places, :image_file_name
  end
end
