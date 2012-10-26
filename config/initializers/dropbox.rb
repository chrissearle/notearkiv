require 'dropbox_sdk'

DROPBOX_SESSION_CACHE_KEY = "dropbox.session".freeze
DROPBOX_FILE_LIST_CACHE_KEY = "dropbox.file.list".freeze
DROPBOX_FILE_LIST_TIMESTAMP_CACHE_KEY = "dropbox.file.timestamp".freeze
DROPBOX_FILE_MEDIA_PREFIX_CACHE_KEY = "dropbox.media.".freeze

DROPBOX_FILE_ICONS = {
    :pdf => 'icon-book',
    :zip => 'icon-download-alt',
    :mp3 => 'icon-music',
    :wav => 'icon-music',
    :mov => 'icon-film',
    :mp4 => 'icon-film',
    :m4a => 'icon-music',
    :png => 'icon-camera',
    :jpeg => 'icon-camera',
    :jpg => 'icon-camera',
    :gif => 'icon-camera',
    :default => 'icon-file'
}.freeze
