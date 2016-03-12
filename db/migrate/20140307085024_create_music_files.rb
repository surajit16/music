class CreateMusicFiles < ActiveRecord::Migration
  def change
    create_table :music_files do |t|
      t.string :name
      t.references :music_album
      t.integer :creator_id

      t.timestamps
    end
    add_index :music_files, :music_album_id
  end
end
