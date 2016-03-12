class MusicFile < ActiveRecord::Base
  belongs_to :music_album
  belongs_to :creator, :class_name => 'User'

  validates :name, :presence=>true
end
