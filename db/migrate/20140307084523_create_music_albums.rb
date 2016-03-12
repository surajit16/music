class CreateMusicAlbums < ActiveRecord::Migration
  def change
    create_table :music_albums do |t|
      t.string :name
      t.integer :creator_id

      t.timestamps
    end
  end
end
