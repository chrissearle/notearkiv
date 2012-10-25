class DropboxWrapper
  def self.get_auth_url(url)
    s = DropboxSession.new(ENV['DROPBOX_CONSUMER_KEY'], ENV['DROPBOX_CONSUMER_SECRET'])

    Rails.cache.write DROPBOX_SESSION_CACHE_KEY, s.serialize

    return s.get_authorize_url url
  end

  def self.authorize
    s = DropboxSession.deserialize(Rails.cache.read(DROPBOX_SESSION_CACHE_KEY))

    s.get_access_token

    Rails.cache.write DROPBOX_SESSION_CACHE_KEY, s.serialize
  end

  def self.get_client
    serialized_session = Rails.cache.read(DROPBOX_SESSION_CACHE_KEY)

    unless serialized_session
      return nil
    end

    s = DropboxSession.deserialize(serialized_session)

    unless s
      return nil
    end

    begin
      DropboxClient.new(s, :app_folder)
    rescue DropboxAuthError
      nil
    end
  end

  def self.refresh
    files = get_path('/')

    Rails.cache.write(DROPBOX_FILE_LIST_CACHE_KEY, files)
    Rails.cache.write(DROPBOX_FILE_LIST_TIMESTAMP_CACHE_KEY, DateTime.now)

    files
  end

  def self.get_files
    Rails.cache.read(DROPBOX_FILE_LIST_CACHE_KEY)
  end

  def self.get_timestamp
    Rails.cache.read(DROPBOX_FILE_LIST_TIMESTAMP_CACHE_KEY)
  end

  def self.get_path(folder)
    self.get_path_with_client(folder, get_client)
  end

  def self.get_path_with_client(folder, client)
    files = []

    Rails.logger.debug("Walking #{folder}")

    metadata = client.metadata(folder)

    unless metadata['contents']
      metadata['media_link'] = client.media(metadata['path'])['url']
      return [metadata]
    end

    metadata['contents'].each do |file|
      if file['is_dir']
        files = files | get_path_with_client(file['path'], client)
      else
        files << file
      end
    end

    files
  end

  def self.remove(path)
    begin
      client = get_client

      return unless client

      client.file_delete(path)

      refresh
    rescue DropboxAuthError
      return nil
    rescue DropboxError
      return nil
    end
  end

  def self.get_media(path)
    begin
      client = get_client

      return nil unless client

      client.media(path)['url']
    rescue DropboxAuthError
      return nil
    end
  end

  def self.upload(file, filename)
    begin
      client = get_client

      return nil unless client

      client.put_file(filename, file.read)
    rescue DropboxAuthError
      return nil
    end
  end
end
