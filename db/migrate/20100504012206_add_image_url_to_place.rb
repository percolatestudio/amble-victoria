class AddImageUrlToPlace < ActiveRecord::Migration
  def self.up
    # temporarily make it just a url, pointing to a flickr etc image
    add_column :places, :image_url, :string
  end

  def self.down
    remove_column :places, :image_url
  end
end
