class MusicAlbum < ActiveRecord::Base
  attr_accessible :name, :cover, :cover_file_path

  has_many :music_files
  belongs_to :creator, :class_name => 'User'
  validates :name, :presence=>true

  mount_uploader :cover, ImageUploader

  def cover_file_path
    file_path = nil
    if self.cover.present?
      file_path = self.cover_url(:thumb)
    elsif self.cover_file_path.present? and File.exist?(self.cover_file_path)
      file_path = self.cover_file_path
    end
    return file_path
  end
end
