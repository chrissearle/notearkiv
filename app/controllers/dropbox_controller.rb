# coding: UTF-8

class DropboxController < ApplicationController
  filter_access_to :all

  before_filter :get_session, :except => [:authorize]
  before_filter :get_client, :except => [:authorize]
  before_filter :get_info, :except => [:authorize]

  DROPBOX_FILE_LIST_CACHE_KEY = "dropbox.file.list".freeze
  DROPBOX_FILE_LIST_TIMESTAMP_CACHE_KEY = "dropbox.file.timestamp".freeze

  def index
    if params[:refresh]
      files = get_path('/')
      Rails.cache.write(DROPBOX_FILE_LIST_CACHE_KEY, files)
      Rails.cache.write(DROPBOX_FILE_LIST_TIMESTAMP_CACHE_KEY, DateTime.now)

      return redirect_to dropbox_index_path
    end

    if params[:path]
      @files = get_path(params[:path])
    else
      @files = Rails.cache.read(DROPBOX_FILE_LIST_CACHE_KEY)
      @timestamp = Rails.cache.read(DROPBOX_FILE_LIST_TIMESTAMP_CACHE_KEY)

      unless @files
        @files = []
      end
    end
  end

  def show

  end

  def authorize
    unless params[:oauth_token]
      Rails.logger.debug("Creating new dropbox session")
      dbsession = DropboxSession.new(ENV['DROPBOX_KEY'], ENV['DROPBOX_SECRET'])

      Rails.logger.debug("Storing new dropbox session in cache")
      Rails.cache.write :dropbox_session, dbsession.serialize

      Rails.logger.debug("Sending to dropbox")
      redirect_to dbsession.get_authorize_url url_for(:action => 'authorize')
    else
      Rails.logger.debug("Retrieving dropbox session from cache to authorize")
      dbsession = DropboxSession.deserialize(Rails.cache.read(:dropbox_session))

      dbsession.get_access_token

      Rails.logger.debug("Storing authorized dropbox session in cache")
      Rails.cache.write :dropbox_session, dbsession.serialize

      redirect_to :action => 'index'
    end
  end

  private

  def get_session
    @dbsession = DropboxSession.deserialize(Rails.cache.read(:dropbox_session))
  end

  def get_client
    begin
      @dbclient = DropboxClient.new(@dbsession, :app_folder)
    rescue DropboxAuthError
      return redirect_to authorize_dropbox_index_path
    end
  end

  def get_info
    @info = @dbclient.account_info
  end

  def get_path(folder)
    files = []

    Rails.logger.debug("Walking #{folder}")

    metadata = @dbclient.metadata(folder)

    unless metadata['contents']
      metadata['media_link'] = @dbclient.media(metadata['path'])['url']
      return [metadata]
    end

    metadata['contents'].each do |file|
      if file['is_dir']
        files = files | get_path(file['path'])
      else
        files << file
      end
    end

    files
  end
end