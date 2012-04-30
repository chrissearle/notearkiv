# coding: UTF-8

class DropboxController < ApplicationController
  filter_access_to :all

  before_filter :get_client, :except => [:authorize]
  before_filter :get_info, :except => [:authorize]

  DROPBOX_FILE_LIST_CACHE_KEY = "dropbox.file.list".freeze
  DROPBOX_FILE_LIST_TIMESTAMP_CACHE_KEY = "dropbox.file.timestamp".freeze

  def index
    if params[:refresh]
      files = DropboxWrapper.get_path('/')

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
    if params[:oauth_token]
      DropboxWrapper.authorize

      redirect_to :action => 'index'
    else
      redirect_to DropboxWrapper.get_auth_url(url_for(:action => 'authorize'))
    end
  end

  private

  def get_client
    begin
      @dbclient = DropboxWrapper.get_client

      unless @dbclient
        return redirect_to authorize_dropbox_index_path
      end
    rescue DropboxAuthError
      return redirect_to authorize_dropbox_index_path
    end
  end

  def get_info
    @info = @dbclient.account_info
  end
end