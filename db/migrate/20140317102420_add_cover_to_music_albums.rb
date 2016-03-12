class AddCoverToMusicAlbums < ActiveRecord::Migration
  def change
    add_column :music_albums, :cover, :string
    add_column :music_albums, :cover_file_path, :string
  end
end
