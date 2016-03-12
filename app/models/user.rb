class User < ActiveRecord::Base
  attr_accessible :email, :name,:password, :password_confirmation, :is_admin, :verified, :token, :image, :remote_image_url
  has_secure_password

  has_many   :music_albums, :foreign_key => 'creator_id'
  has_many   :music_files, :foreign_key => 'creator_id'

  validates :password, :presence=>true, :on => :create,:length => { :minimum => 4 }
  validates :name, :presence=>true
  validates :email, :presence=>true, :uniqueness => true

  mount_uploader :image, ImageUploader

end
