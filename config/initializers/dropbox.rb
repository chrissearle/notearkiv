require 'dropbox_sdk'

DROPBOX_SESSION_CACHE_KEY = "dropbox.session"
DROPBOX_FILE_LIST_CACHE_KEY = "dropbox.file.list"
DROPBOX_FILE_LIST_TIMESTAMP_CACHE_KEY = "dropbox.file.timestamp"
DROPBOX_FILE_MEDIA_PREFIX_CACHE_KEY = "dropbox.media."

DROPBOX_FILE_ICONS = {
    :pdf => 'glyphicon glyphicon-book',
    :zip => 'glyphicon glyphicon-download-alt',
    :mp3 => 'glyphicon glyphicon-music',
    :wav => 'glyphicon glyphicon-music',
    :mov => 'glyphicon glyphicon-film',
    :mp4 => 'glyphicon glyphicon-film',
    :m4a => 'glyphicon glyphicon-music',
    :png => 'glyphicon glyphicon-camera',
    :jpeg => 'glyphicon glyphicon-camera',
    :jpg => 'glyphicon glyphicon-camera',
    :gif => 'glyphicon glyphicon-camera',
    :default => 'glyphicon glyphicon-file'
}.freeze
