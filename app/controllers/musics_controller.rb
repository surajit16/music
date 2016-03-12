class MusicsController < ApplicationController
  before_filter :login_required

  def index
    @music_albums=MusicAlbum.find(:all, :order=>"name")
  end

  def new
    @music_albums=MusicAlbum.all
    @music_album=MusicAlbum.new
  end

  def create
    @music_album=nil
    if params[:music_album][:id].present?
      @music_album=MusicAlbum.find(params[:music_album][:id])
    else
      all_params=params[:music_album].dup
      all_params.delete(:id)
      @music_album=MusicAlbum.new(all_params)
      if @music_album.save
        render 'users/close_create'
      else
        @music_albums=MusicAlbum.all
        render 'new'
      end
    end
  end

  def show_album
    render :layout=>false
  end
end
